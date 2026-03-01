package linkedlist

type Element[T any] struct {
	next, prev *Element[T]
	list       *List[T]
	Value      T
}

type List[T any] struct {
	root Element[T]
	len  int
}

func (e *Element[T]) Next() *Element[T] {
	if p := e.next; e.list != nil && p != &e.list.root {
		return p
	}
	return nil
}

func (e *Element[T]) Prev() *Element[T] {
	if p := e.prev; e.list != nil && p != &e.list.root {
		return p
	}
	return nil
}

func (l *List[T]) Init() *List[T] {
	l.root.next = &l.root
	l.root.prev = &l.root
	l.len = 0
	return l
}

func New[T any]() *List[T] {
	return new(List[T]).Init()
}

func (l *List[T]) Len() int { return l.len }

func (l *List[T]) Front() *Element[T] {
	if l.len == 0 {
		return nil
	}
	return l.root.next
}

func (l *List[T]) Back() *Element[T] {
	if l.len == 0 {
		return nil
	}
	return l.root.prev
}

func (l *List[T]) remove(e *Element[T]) {
	e.prev.next = e.next
	e.next.prev = e.prev
	e.next = nil
	e.prev = nil
	e.list = nil
	l.len--
}

func (l *List[T]) Remove(e *Element[T]) {
	if e.list == l && e != &l.root {
		l.remove(e)
	}
}

func (l *List[T]) insert(e, at *Element[T]) *Element[T] {
	e.prev = at
	e.next = at.next
	e.prev.next = e
	e.next.prev = e
	e.list = l
	l.len++
	return e
}

func (l *List[T]) insertValue(v T, at *Element[T]) *Element[T] {
	return l.insert(&Element[T]{Value: v}, at)
}

func (l *List[T]) PushFront(v T) *Element[T] {
	return l.insertValue(v, &l.root)
}

func (l *List[T]) PushBack(v T) *Element[T] {
	return l.insertValue(v, l.root.prev)
}

func (l *List[T]) PushFrontElement(e *Element[T]) *Element[T] {
	return l.insert(e, &l.root)
}

func (l *List[T]) InsertBefore(v T, at *Element[T]) *Element[T] {
	if at.list != l {
		return nil
	}
	return l.insertValue(v, at.prev)
}
func (l *List[T]) InsertAfter(v T, at *Element[T]) *Element[T] {
	if at.list != l {
		return nil
	}
	return l.insertValue(v, at)
}

func (l *List[T]) move(e, at *Element[T]) {
	if e == at {
		return
	}
	e.prev.next = e.next
	e.next.prev = e.prev

	e.prev = at
	e.next = at.next
	e.prev.next = e
	e.next.prev = e
}

func (l *List[T]) MoveToFront(e *Element[T]) {
	if e.list != l || l.root.next == e {
		return
	}
	l.move(e, &l.root)
}

func (l *List[T]) MoveToBack(e *Element[T]) {
	if e.list != l || l.root.prev == e {
		return
	}
	l.move(e, l.root.prev)
}
