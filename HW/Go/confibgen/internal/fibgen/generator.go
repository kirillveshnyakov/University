package fibonacci

import (
	"errors"
	"runtime"
	"sync/atomic"
)

type Generator interface {
	Next() uint64
}

var _ Generator = (*generatorImpl)(nil)

var ErrUnlock = errors.New("unlock of unlocked generator")
var ErrOverflow = errors.New("generator overflow")

type generatorImpl struct {
	a uint64
	b uint64
	L atomic.Bool
}

func NewGenerator() *generatorImpl {
	return &generatorImpl{
		a: 0,
		b: 0,
		L: atomic.Bool{},
	}
}

func (g *generatorImpl) Lock() {
	for !g.L.CompareAndSwap(false, true) {
		runtime.Gosched()
	}
}

func (g *generatorImpl) Unlock() {
	if !g.L.CompareAndSwap(true, false) {
		panic(ErrUnlock)
	}
}

func (g *generatorImpl) Next() uint64 {
	g.Lock()
	defer g.Unlock()
	if g.a > ^uint64(0)-g.b {
		panic(ErrOverflow)
	}
	if g.a == 0 && g.b == 0 {
		g.a = 1
		return 0
	}
	g.a, g.b = g.b, g.a
	g.b += g.a
	return g.b
}
