package digest

import (
	"math/cmplx"
	"math/rand/v2"
	"unsafe"
)

// GetCharByIndex returns the i-th character from the given string.
func GetCharByIndex(str string, idx int) rune {
	i := 0
	for _, r := range str {
		if i == idx {
			return r
		}
		i++
	}
	panic("runtime error: index out of range")
}

// GetStringBySliceOfIndexes returns a string formed by concatenating specific characters from the input string based
// on the provided indexes.
func GetStringBySliceOfIndexes(str string, indexes []int) string {
	result := make([]rune, len(indexes))
	for ind, i := range indexes {
		result[ind] = GetCharByIndex(str, i)
	}
	return string(result)
}

// ShiftPointer shifts the given pointer by the specified number of bytes using unsafe.Add.
func ShiftPointer(pointer **int, shift int) {
	*pointer = (*int)(unsafe.Add(unsafe.Pointer(*pointer), shift))
}

// IsComplexEqual compares two complex numbers and determines if they are equal.
func IsComplexEqual(a, b complex128) bool {
	if cmplx.IsNaN(a) || cmplx.IsNaN(b) {
		return false
	}
	const epsilon = 1e-6
	return a == b || cmplx.Abs(a-b) < epsilon
}

// GetRootsOfQuadraticEquation returns two roots of a quadratic equation ax^2 + bx + c = 0.
func GetRootsOfQuadraticEquation(a, b, c float64) (complex128, complex128) {
	complexA := complex(a, 0)
	complexB := complex(b, 0)
	sqrtD := cmplx.Sqrt(complex(b*b-4*a*c, 0))
	return (-complexB + sqrtD) / (2 * complexA), (-complexB - sqrtD) / (2 * complexA)
}

func QSort(arr []int, left, right int) {
	if right-left < 1 {
		return
	}
	pivot := arr[rand.IntN(right-left+1)+left]
	l := left
	r := right + 1
	for l < r {
		for arr[l] < pivot {
			l++
		}
		r--
		for arr[r] > pivot {
			r--
		}
		if l < r {
			arr[l], arr[r] = arr[r], arr[l]
		}
	}
	QSort(arr, left, r)
	QSort(arr, r+1, right)
}

// Sort sorts in-place the given slice of integers in ascending order.
func Sort(source []int) {
	QSort(source, 0, len(source)-1)
}

// ReverseSliceOne in-place reverses the order of elements in the given slice.
func ReverseSliceOne(s []int) {
	size := len(s)
	for i := 0; i < size/2; i++ {
		s[i], s[size-i-1] = s[size-i-1], s[i]
	}
}

// ReverseSliceTwo returns a new slice of integers with elements in reverse order compared to the input slice.
// The original slice remains unmodified.
func ReverseSliceTwo(s []int) []int {
	result := make([]int, len(s))
	copy(result, s)
	ReverseSliceOne(result)
	return result
}

// SwapPointers swaps the values of two pointers.
func SwapPointers(a, b *int) {
	*a, *b = *b, *a
}

// IsSliceEqual compares two slices of integers and returns true if they contain the same elements in the same order.
func IsSliceEqual(a, b []int) bool {
	if len(a) != len(b) {
		return false
	}
	for i, e := range a {
		if e != b[i] {
			return false
		}
	}
	return true
}

// DeleteByIndex deletes the element at the specified index from the slice and returns a new slice.
// The original slice remains unmodified.
func DeleteByIndex(s []int, idx int) []int {
	result := make([]int, 0)
	result = append(result, s[:idx]...)
	result = append(result, s[idx+1:]...)
	return result
}
