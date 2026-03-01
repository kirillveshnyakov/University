package lfucache

import (
	"errors"
	"iter"

	"github.com/igoroutine-courses/gonature.lfucache/internal/linkedlist"
)

var ErrKeyNotFound = errors.New("key not found")

const DefaultCapacity = 5

type Cache[K comparable, V any] interface {
	Get(key K) (V, error)
	Put(key K, value V)
	All() iter.Seq2[K, V]
	Size() int
	Capacity() int
	GetKeyFrequency(key K) (int, error)
}

type freqNode[K comparable, V any] struct {
	freq int
	list *linkedlist.List[node[K, V]]
}

type node[K comparable, V any] struct {
	key   K
	value V
	freq  *linkedlist.Element[freqNode[K, V]]
}

type cacheImpl[K comparable, V any] struct {
	freqList     *linkedlist.List[freqNode[K, V]]
	keyToElement map[K]*linkedlist.Element[node[K, V]]
	capacity     int
}

func (c *cacheImpl[K, V]) init(capacity int) *cacheImpl[K, V] {
	if capacity < 0 {
		panic("invalid capacity")
	}
	return &cacheImpl[K, V]{
		freqList:     linkedlist.New[freqNode[K, V]](),
		keyToElement: make(map[K]*linkedlist.Element[node[K, V]], capacity),
		capacity:     capacity,
	}
}

func New[K comparable, V any](args ...int) *cacheImpl[K, V] {
	switch len(args) {
	case 0:
		return new(cacheImpl[K, V]).init(DefaultCapacity)
	case 1:
		return new(cacheImpl[K, V]).init(args[0])
	default:
		panic("invalid args count")
	}
}

func (c *cacheImpl[K, V]) pushNewFreq(at *linkedlist.Element[freqNode[K, V]], newFreq int) *linkedlist.Element[freqNode[K, V]] {
	newFreqNode := freqNode[K, V]{freq: newFreq, list: linkedlist.New[node[K, V]]()}
	if at == nil {
		return c.freqList.PushFront(newFreqNode)
	}
	return c.freqList.InsertAfter(newFreqNode, at)
}

func (c *cacheImpl[K, V]) removeFreqListNode(el *linkedlist.Element[freqNode[K, V]], link *linkedlist.Element[node[K, V]]) {
	el.Value.list.Remove(link)
	if el.Value.list.Len() == 0 {
		c.freqList.Remove(el)
	}
}

func (c *cacheImpl[K, V]) incFreq(key K) {
	link := c.keyToElement[key]
	nowFreqEl := link.Value.freq
	nowFreq := nowFreqEl.Value.freq
	nextFreqEl := nowFreqEl.Next()

	if nextFreqEl == nil || nextFreqEl.Value.freq != nowFreq+1 {
		if nowFreqEl.Value.list.Len() == 1 {
			nowFreqEl.Value.freq++
			return
		}
		nextFreqEl = c.pushNewFreq(nowFreqEl, nowFreq+1)
	}

	c.removeFreqListNode(nowFreqEl, link)

	nextFreqEl.Value.list.PushFrontElement(link)
	nextFreqEl.Value.list.Front().Value.freq = nextFreqEl
	c.keyToElement[key] = nextFreqEl.Value.list.Front()
}

func (c *cacheImpl[K, V]) addNewNode(key K, value V) {
	firstFreqEl := c.freqList.Front()
	if firstFreqEl == nil || firstFreqEl.Value.freq != 1 {
		firstFreqEl = c.pushNewFreq(nil, 1)
	}
	c.keyToElement[key] = firstFreqEl.Value.list.PushFront(node[K, V]{
		key:   key,
		value: value,
		freq:  firstFreqEl,
	})
}

func (c *cacheImpl[K, V]) updateMinFreq(key K, value V) {
	firstFreqEl := c.freqList.Front()
	lastNodeEl := firstFreqEl.Value.list.Back()

	delete(c.keyToElement, lastNodeEl.Value.key)

	if firstFreqEl.Value.freq == 1 || firstFreqEl.Value.list.Len() == 1 {
		firstFreqEl.Value.freq = 1
		firstFreqEl.Value.list.MoveToFront(lastNodeEl)
	} else {
		c.removeFreqListNode(firstFreqEl, lastNodeEl)
		firstFreqEl = c.pushNewFreq(nil, 1)
		firstFreqEl.Value.list.PushFrontElement(lastNodeEl)
	}
	lastNodeEl.Value.value = value
	lastNodeEl.Value.key = key
	c.keyToElement[key] = firstFreqEl.Value.list.Front()
}

func (c *cacheImpl[K, V]) Get(key K) (V, error) {
	if link, ok := c.keyToElement[key]; ok {
		c.incFreq(key)
		return link.Value.value, nil
	}
	var zero V
	return zero, ErrKeyNotFound
}

func (c *cacheImpl[K, V]) Put(key K, value V) {
	if c.Capacity() == 0 {
		return
	}
	if link, ok := c.keyToElement[key]; ok {
		link.Value.value = value
		c.incFreq(key)
		return
	}
	if c.Size() == c.capacity {
		c.updateMinFreq(key, value)
		return
	}
	c.addNewNode(key, value)
}

func (c *cacheImpl[K, V]) All() iter.Seq2[K, V] {
	return func(yield func(K, V) bool) {
		for freqEl := c.freqList.Back(); freqEl != nil; freqEl = freqEl.Prev() {
			list := freqEl.Value.list
			for nodeEl := list.Front(); nodeEl != nil; nodeEl = nodeEl.Next() {
				n := nodeEl.Value
				if !yield(n.key, n.value) {
					return
				}
			}
		}
	}
}

func (c *cacheImpl[K, V]) Size() int {
	return len(c.keyToElement)
}

func (c *cacheImpl[K, V]) Capacity() int {
	return c.capacity
}

func (c *cacheImpl[K, V]) GetKeyFrequency(key K) (int, error) {
	if link, ok := c.keyToElement[key]; ok {
		return link.Value.freq.Value.freq, nil
	}
	return 0, ErrKeyNotFound
}
