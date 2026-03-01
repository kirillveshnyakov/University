package fact

import (
	"context"
	"errors"
	"io"
	"strconv"
	"strings"
	"sync"
)

var (
	ErrFactorizationCancelled = errors.New("cancelled")
	ErrWriterInteraction      = errors.New("writer interaction")
)

type Factorizer interface {
	Factorize(ctx context.Context, numbers []int, writer io.Writer) error
}

type factorizerImpl struct {
	FactorizationWorkers int
	WriteWorkers         int
}

func New(opts ...FactorizeOption) (*factorizerImpl, error) {
	result := &factorizerImpl{
		FactorizationWorkers: 1,
		WriteWorkers:         1,
	}
	for _, opt := range opts {
		opt(result)
	}
	if result.FactorizationWorkers < 1 {
		return nil, errors.New("incorrect number of factorization workers: " + strconv.Itoa(result.FactorizationWorkers))
	}
	if result.WriteWorkers < 1 {
		return nil, errors.New("incorrect number of write workers:" + strconv.Itoa(result.WriteWorkers))
	}
	return result, nil
}

type FactorizeOption func(*factorizerImpl)

func WithFactorizationWorkers(workers int) FactorizeOption {
	return func(f *factorizerImpl) {
		f.FactorizationWorkers = workers
	}
}

func WithWriteWorkers(workers int) FactorizeOption {
	return func(f *factorizerImpl) {
		f.WriteWorkers = workers
	}
}

func Generate[T any](ctx context.Context, data []T) <-chan T {
	result := make(chan T)

	go func() {
		defer close(result)

		for i := 0; i < len(data); i++ {
			select {
			case <-ctx.Done():
				return
			case result <- data[i]:
			}
		}
	}()

	return result
}

func FactorizeNumber[T int](numberT T) (string, error) {
	number := int(numberT)
	result := strings.Builder{}
	result.WriteString(strconv.Itoa(number) + " = ")
	if number < 0 {
		result.WriteString("-1 * ")
		if number%2 == 0 {
			result.WriteString("2 * ")
			number /= 2
		}
		number *= -1
	}
	for i := 2; i <= number/i; i++ {
		if number%i == 0 {
			result.WriteString(strconv.Itoa(i) + " * ")
			number /= i
			i--
		}
	}
	result.WriteString(strconv.Itoa(number) + "\n")
	return result.String(), nil
}

func WriterFuncConstructor(writer io.Writer) func(string) (int, error) {
	return func(str string) (int, error) {
		return writer.Write([]byte(str))
	}
}

func WorkerPoolWithError[T any, R any](
	ctx context.Context,
	errorUpdate func(args ...error),
	workersCount int,
	transform func(T) (R, error),
	input <-chan T,
	withOutput bool,
	output chan<- R,
) *sync.WaitGroup {
	wg := new(sync.WaitGroup)
	for i := 0; i < workersCount; i++ {
		wg.Go(func() {
			for {
				select {
				case <-ctx.Done():
					errorUpdate(ErrFactorizationCancelled, context.Cause(ctx))
					return
				case v, ok := <-input:
					if !ok {
						return
					}

					res, err := transform(v)
					if err != nil {
						errorUpdate(ErrWriterInteraction, err)
						return
					}

					if withOutput {
						select {
						case <-ctx.Done():
							errorUpdate(ErrFactorizationCancelled, context.Cause(ctx))
							return
						case output <- res:
						}
					}
				}
			}
		})
	}
	return wg
}

func (f *factorizerImpl) Factorize(
	ctx context.Context,
	number []int,
	writer io.Writer,
) error {
	newCtx, cancel := context.WithCancel(ctx)
	defer cancel()

	var returnError error
	once := new(sync.Once)

	updateErrorFunc := func(errs ...error) {
		once.Do(func() {
			cancel()
			returnError = errors.Join(returnError, errors.Join(errs...))
		})
	}

	numberChan := Generate(newCtx, number)
	factorizeNumbers := make(chan string)

	wgFactorization := WorkerPoolWithError(newCtx, updateErrorFunc, f.FactorizationWorkers, FactorizeNumber, numberChan, true, factorizeNumbers)

	wgWriters := WorkerPoolWithError(newCtx, updateErrorFunc, f.WriteWorkers, WriterFuncConstructor(writer), factorizeNumbers, false, nil)

	wgFactorization.Wait()
	close(factorizeNumbers)
	wgWriters.Wait()

	return returnError
}
