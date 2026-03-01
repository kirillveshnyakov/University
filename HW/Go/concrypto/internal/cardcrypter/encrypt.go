package cardcrypter

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"runtime"
	"sync"
	"unsafe"
)

type CardNumber [16]byte

type Card struct {
	ID     string
	Number CardNumber
}

type Crypter interface {
	Encrypt(cards []Card, key []byte) ([]string, error)
}

type crypterImpl struct {
	workers int
}

func New(opts ...CrypterOption) *crypterImpl {
	c := &crypterImpl{
		workers: runtime.GOMAXPROCS(0),
	}
	for _, opt := range opts {
		opt(c)
	}
	return c
}

type CrypterOption func(*crypterImpl)

func WithWorkers(workers int) CrypterOption {
	return func(c *crypterImpl) {
		c.workers = workers
	}
}

func (c *crypterImpl) Encrypt(cards []Card, key []byte) ([]string, error) {
	if len(cards) == 0 {
		return []string{}, nil
	}

	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, err
	}

	workers := c.workers
	if workers <= 0 {
		return nil, errors.New("negative workers")
	}

	if workers > len(cards) {
		workers = len(cards)
	}

	var returnErr error
	errorOnce := new(sync.Once)
	nonceSize := gcm.NonceSize()
	out := make([]string, len(cards))
	wg := new(sync.WaitGroup)
	chunkSize := (len(cards) + workers - 1) / workers

	for w := 0; w < workers; w++ {
		first := w * chunkSize
		last := first + chunkSize
		if last > len(cards) {
			last = len(cards)
		}
		wg.Add(1)
		go func(start, end int) {
			nonce := make([]byte, nonceSize)
			buf := make([]byte, nonceSize, nonceSize+16+gcm.Overhead())
			defer wg.Done()
			for i := start; i < end; i++ {
				// несмотря на гарантию того, что ошибки не будет,
				// проверка все равно производится на случай изменения кода функции
				// или других непредвиденных ситуаций, пока гарантия сохраняется
				// проверка не ухудшает асимптотику и не работает с sync.Once
				if _, err := rand.Read(nonce); err != nil {
					errorOnce.Do(
						func() {
							returnErr = err
						},
					)
				}
				if returnErr != nil {
					return
				}

				copy(buf, nonce)

				id := unsafe.Slice(unsafe.StringData(cards[i].ID), len(cards[i].ID))
				result := gcm.Seal(
					buf,
					nonce,
					cards[i].Number[:],
					id,
				)

				hexBuf := make([]byte, hex.EncodedLen(len(result)))
				hex.Encode(hexBuf, result)
				out[i] = unsafe.String(unsafe.SliceData(hexBuf), len(hexBuf))

				for j := range nonce {
					nonce[j] = 0
				}
			}
		}(first, last)
	}

	wg.Wait()

	if returnErr != nil {
		return nil, returnErr
	}
	return out, nil
}
