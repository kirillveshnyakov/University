#pragma once

#include <type_traits>

namespace ct {

template <typename T>
class Vector {
  static_assert(std::is_nothrow_move_constructible_v<T> || std::is_copy_constructible_v<T>);

public:
  using ValueType = T;

  using Reference = T&;
  using ConstReference = const T&;

  using Pointer = T*;
  using ConstPointer = const T*;

  using Iterator = Pointer;
  using ConstIterator = ConstPointer;

private:
  static void free(Pointer data, size_t size) {
    for (size_t i = size; i > 0; i--) {
      data[i - 1].~T();
    }
  }

  static Pointer alloc_data(const size_t cnt) {
    return static_cast<Pointer>(operator new(sizeof(T) * cnt, static_cast<std::align_val_t>(alignof(T))));
  }

  static void dealloc_data(Pointer data) noexcept {
    operator delete(data, static_cast<std::align_val_t>(alignof(T)));
  }

  void change_size_capacity(const size_t new_capacity) {
    Vector tmp(new_capacity);
    for (size_t i = 0; i < size(); i++) {
      new (tmp.data() + i) T(std::move_if_noexcept(data()[i]));
      ++tmp._size;
    }
    swap(tmp);
  }

public:
  // O(1) nothrow
  void swap(Vector& other) noexcept {
    std::swap(_size, other._size);
    std::swap(_capacity, other._capacity);
    std::swap(_data, other._data);
  }

  // O(1) nothrow
  Vector() noexcept = default;

  // O(1) strong
  explicit Vector(size_t capacity)
      : _capacity(capacity)
      , _data(alloc_data(capacity)) {}

  // O(N) strong
  Vector(const Vector& other) {
    if (other.empty()) {
      return;
    }
    Vector tmp(other.size());
    for (size_t i = 0; i < other.size(); i++) {
      new (tmp.data() + i) T(other[i]);
      ++tmp._size;
    }
    swap(tmp);
  }

  // O(1) strong
  Vector(Vector&& other)
      : Vector() {
    swap(other);
  }

  // O(N) strong
  Vector& operator=(const Vector& other) {
    if (this != &other) {
      Vector tmp(other);
      swap(tmp);
    }
    return *this;
  }

  // O(1) strong
  Vector& operator=(Vector&& other) {
    Vector tmp(std::move(other));
    swap(tmp);
    return *this;
  }

  // O(N) nothrow
  void clear() noexcept {
    if (capacity() == 0) {
      return;
    }
    free(data(), size());
    _size = 0;
  }

  // O(N) nothrow
  ~Vector() noexcept {
    clear();
    dealloc_data(data());
  }

  // O(1) nothrow
  Reference operator[](size_t index) {
    return data()[index];
  }

  // O(1) nothrow
  ConstReference operator[](size_t index) const {
    return data()[index];
  }

  // O(1) nothrow
  Pointer data() noexcept {
    return _data;
  }

  // O(1) nothrow
  ConstPointer data() const noexcept {
    return _data;
  }

  // O(1) nothrow
  size_t size() const noexcept {
    return _size;
  }

  // O(1) nothrow
  Reference front() {
    return data()[0];
  }

  // O(1) nothrow
  ConstReference front() const {
    return data()[0];
  }

  // O(1) nothrow
  Reference back() {
    return data()[size() - 1];
  }

  // O(1) nothrow
  ConstReference back() const {
    return data()[size() - 1];
  }

  // O(N) strong
  void reserve(size_t new_capacity) {
    if (new_capacity > capacity()) {
      change_size_capacity(new_capacity);
    }
  }

  // O(N) strong
  void shrink_to_fit() {
    if (capacity() > size()) {
      change_size_capacity(size());
    }
  }

  // O(1)* strong
  void push_back(const T& value) {
    if (size() == capacity()) {
      Vector tmp((capacity() == 0) ? 1 : size() * 2);
      new (tmp.data() + size()) T(value);
      try {
        for (size_t i = 0; i < size(); i++) {
          new (tmp.data() + i) T(std::move_if_noexcept(data()[i]));
          ++tmp._size;
        }
      } catch (...) {
        tmp.data()[size()].~T();
        throw;
      }
      swap(tmp);
    } else {
      new (data() + size()) T(value);
    }
    _size++;
  }

  // O(1)* strong if move nothrow
  void push_back(T&& value) {
    if (size() == capacity()) {
      Vector tmp((capacity() == 0) ? 1 : size() * 2);
      new (tmp.data() + size()) T(std::move(value));
      try {
        for (size_t i = 0; i < size(); i++) {
          new (tmp.data() + i) T(std::move_if_noexcept(data()[i]));
          ++tmp._size;
        }
      } catch (...) {
        tmp.data()[size()].~T();
        throw;
      }
      swap(tmp);
    } else {
      new (data() + size()) T(std::move(value));
    }
    _size++;
  }

  // O(1) nothrow
  void pop_back() noexcept {
    _data[--_size].~T();
  }

  // O(1) nothrow
  bool empty() const noexcept {
    return size() == 0;
  }

  // O(1) nothrow
  size_t capacity() const noexcept {
    return _capacity;
  }

  // O(1) nothrow
  Iterator begin() noexcept {
    return data();
  }

  // O(1) nothrow
  Iterator end() noexcept {
    return begin() + size();
  }

  // O(1) nothrow
  ConstIterator begin() const noexcept {
    return data();
  }

  // O(1) nothrow
  ConstIterator end() const noexcept {
    return begin() + size();
  }

  // O(N) strong
  Iterator insert(ConstIterator pos, const T& value) {
    size_t ind = pos - begin();
    push_back(value);
    for (Iterator it = end() - 1; it > begin() + ind; --it) {
      std::iter_swap(it, it - 1);
    }
    return begin() + ind;
  }

  // O(N) strong if move nothrow
  Iterator insert(ConstIterator pos, T&& value) {
    size_t ind = pos - begin();
    push_back(std::move(value));
    for (Iterator it = end() - 1; it > begin() + ind; --it) {
      std::iter_swap(it, it - 1);
    }
    return begin() + ind;
  }

  // O(N) nothrow(swap)
  Iterator erase(ConstIterator pos) {
    return erase(pos, pos + 1);
  }

  // O(N) nothrow(swap)
  Iterator erase(ConstIterator first, ConstIterator last) {
    size_t start = first - begin();
    size_t cnt = last - first;
    for (Iterator it = begin() + start; it != (end() - (last - first)); ++it) {
      std::iter_swap(it, it + cnt);
    }
    for (size_t i = 0; i < cnt; i++) {
      pop_back();
    }
    return begin() + start;
  }

private:
  size_t _capacity = 0;
  size_t _size = 0;
  Pointer _data = nullptr;
};

} // namespace ct
