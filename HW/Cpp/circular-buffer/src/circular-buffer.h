#pragma once

#include <algorithm>
#include <iterator>
#include <memory>

namespace ct {
template <typename T>
class CircularBuffer {
  template <typename U>
  class CircularIterator {
  public:
    using iterator_category = std::random_access_iterator_tag;
    using value_type = T;
    using difference_type = std::ptrdiff_t;
    using reference = U&;
    using pointer = U*;

  private:
    friend class CircularBuffer;

    template <typename R>
    friend class CircularIterator;

    const CircularBuffer* ptr_;
    size_t ind_;

    static size_t add_ind_mod(size_t ind, ptrdiff_t step, size_t mod) {
      return ((ind + step) % mod + mod) % mod;
    }

    static size_t sub_ind_mod(size_t ind, ptrdiff_t step, size_t mod) {
      return ((ind - step) % mod + mod) % mod;
    }

    size_t get_ind() const noexcept {
      return (ptr_->shift_ + ind_) % ptr_->capacity_;
    }

    size_t get_ind(difference_type ind) const noexcept {
      return add_ind_mod(ptr_->shift_, ind, ptr_->capacity_);
    }

  public:
    CircularIterator() = default;

    ~CircularIterator() = default;

    CircularIterator(const CircularBuffer* ptr, size_t ind)
        : ptr_(ptr)
        , ind_(ind) {}

    operator CircularIterator<const U>() const {
      return CircularIterator<const U>(ptr_, ind_);
    }

    reference operator*() const {
      return ptr_->data_[get_ind()];
    }

    reference operator[](std::ptrdiff_t ind) const {
      return ptr_->data_[get_ind(ind_ + ind)];
    }

    pointer operator->() const {
      return ptr_->data_ + get_ind();
    }

    CircularIterator& operator++() {
      ++ind_;
      return *this;
    }

    CircularIterator& operator--() {
      --ind_;
      return *this;
    }

    CircularIterator operator++(int) {
      CircularIterator result = *this;
      ++(*this);
      return result;
    }

    CircularIterator operator--(int) {
      CircularIterator result = *this;
      --(*this);
      return result;
    }

    CircularIterator& operator+=(std::ptrdiff_t step) {
      ind_ += step;
      return *this;
    }

    CircularIterator& operator-=(std::ptrdiff_t step) {
      ind_ -= step;
      return *this;
    }

    friend CircularIterator operator+(const CircularIterator& left, std::ptrdiff_t step) {
      CircularIterator result = left;
      result.ind_ += step;
      return result;
    }

    friend CircularIterator operator+(std::ptrdiff_t step, const CircularIterator& right) {
      CircularIterator result = right;
      result.ind_ += step;
      return result;
    }

    friend CircularIterator operator-(const CircularIterator& left, std::ptrdiff_t step) {
      CircularIterator result = left;
      result.ind_ -= step;
      return result;
    }

    friend CircularIterator operator-(std::ptrdiff_t step, const CircularIterator& right) {
      CircularIterator result = right;
      result.ind_ -= step;
      return result;
    }

    friend difference_type operator-(const CircularIterator& lhs, const CircularIterator& rhs) {
      return static_cast<difference_type>(lhs.ind_) - static_cast<difference_type>(rhs.ind_);
    }

    template <typename R>
    bool operator==(const CircularIterator<R>& other) const {
      return ind_ == other.ind_ && ptr_ == other.ptr_;
    }

    template <typename R>
    bool operator!=(const CircularIterator<R>& other) const {
      return !(*this == other);
    }

    friend bool operator<(const CircularIterator& lhs, const CircularIterator& rhs) {
      return (rhs - lhs) > 0;
    }

    friend bool operator<=(const CircularIterator& lhs, const CircularIterator& rhs) {
      return (lhs < rhs) || (lhs == rhs);
    }

    friend bool operator>(const CircularIterator& lhs, const CircularIterator& rhs) {
      return !(lhs <= rhs);
    }

    friend bool operator>=(const CircularIterator& lhs, const CircularIterator& rhs) {
      return !(lhs < rhs);
    }
  };

public:
  using ValueType = T;

  using Reference = T&;
  using ConstReference = const T&;

  using Pointer = T*;
  using ConstPointer = const T*;

  using Iterator = CircularIterator<T>;
  using ConstIterator = CircularIterator<const T>;

  using ReverseIterator = std::reverse_iterator<Iterator>;
  using ConstReverseIterator = std::reverse_iterator<ConstIterator>;

private:
  // O(1), strong
  template <typename U>
  void push_back_impl(U&& val) {
    if (size() == capacity()) {
      CircularBuffer tmp((capacity() == 0) ? 1 : size() * 2);
      new (tmp.data() + size()) T(std::forward<U>(val));
      std::uninitialized_move_n(begin(), size(), tmp.begin());
      tmp.size_ += size();
      swap(tmp);
    } else {
      new (data() + get_ind(size())) T(std::forward<U>(val));
    }
    ++size_;
  }

  // O(1), strong
  template <typename U>
  void push_front_impl(U&& val) {
    if (size() == capacity()) {
      CircularBuffer tmp(capacity() == 0 ? 1 : size() * 2);
      new (tmp.data()) T(std::forward<U>(val));
      ++tmp.size_;
      std::uninitialized_move_n(begin(), size(), tmp.begin() + 1);
      tmp.size_ += size();
      swap(tmp);
    } else {
      new (data() + get_ind(capacity_ - 1)) T(std::forward<U>(val));
      shift_ = (shift_ + capacity() - 1) % capacity();
      ++size_;
    }
  }

  // O(n), strong
  template <typename U>
  Iterator insert_impl(ConstIterator pos, U&& val) {
    size_t ind = pos - begin();
    if (ind <= size() / 2) {
      push_front(std::forward<U>(val));
      std::rotate(begin(), begin() + 1, begin() + ind + 1);
    } else {
      push_back(std::forward<U>(val));
      std::rotate(begin() + ind, end() - 1, end());
    }
    return begin() + ind;
  }

  static Pointer allocdata_(const size_t cnt) {
    return static_cast<Pointer>(operator new(sizeof(T) * cnt, static_cast<std::align_val_t>(alignof(T))));
  }

  static void deallocdata_(Pointer data) noexcept {
    operator delete(data, static_cast<std::align_val_t>(alignof(T)));
  }

  size_t get_ind(size_t ind) const noexcept {
    return (ind + shift_) % capacity_;
  }

  size_t shift_ = 0;
  size_t size_ = 0;
  size_t capacity_ = 0;
  T* data_ = nullptr;

public:
  // O(1), nothrow
  CircularBuffer() noexcept = default;

  explicit CircularBuffer(size_t capacity)
      : capacity_(capacity)
      , data_(allocdata_(capacity)) {}

  // O(n), strong
  CircularBuffer(const CircularBuffer& other) {
    if (other.empty()) {
      return;
    }
    CircularBuffer tmp(other.size());
    for (size_t i = 0; i < other.size(); i++) {
      new (tmp.data() + i) T(other[other.get_ind(i)]);
      ++tmp.size_;
    }
    swap(tmp);
  }

  // O(1), nothrow
  CircularBuffer(CircularBuffer&& other) noexcept
      : CircularBuffer() {
    swap(other);
  }

  // O(n), strong
  CircularBuffer& operator=(const CircularBuffer& other) {
    if (this != &other) {
      CircularBuffer tmp(other);
      swap(tmp);
    }
    return *this;
  }

  // O(1), nothrow
  CircularBuffer& operator=(CircularBuffer&& other) noexcept {
    CircularBuffer tmp(std::move(other));
    swap(tmp);
    return *this;
  }

  // O(n), nothrow
  ~CircularBuffer() {
    clear();
    deallocdata_(data());
  }

  // O(n), nothrow
  void clear() noexcept {
    if (capacity() != 0) {
      std::destroy_n(begin(), size());
      size_ = 0;
    }
  }

  // O(1), nothrow
  size_t shift() const noexcept {
    return shift_;
  }

  // O(1), nothrow
  size_t size() const noexcept {
    return size_;
  }

  // O(1), nothrow
  bool empty() const noexcept {
    return size() == 0;
  }

  // O(1), nothrow
  size_t capacity() const noexcept {
    return capacity_;
  }

  // O(1), nothrow
  Pointer data() const {
    return data_;
  }

  // O(1), nothrow
  Iterator begin() noexcept {
    return {this, 0};
  }

  // O(1), nothrow
  ConstIterator begin() const noexcept {
    return {this, 0};
  }

  // O(1), nothrow
  Iterator end() noexcept {
    return {this, size()};
  }

  // O(1), nothrow
  ConstIterator end() const noexcept {
    return {this, size()};
  }

  // O(1), nothrow
  ReverseIterator rbegin() noexcept {
    return ReverseIterator(end());
  }

  // O(1), nothrow
  ConstReverseIterator rbegin() const noexcept {
    return ConstReverseIterator(end());
  }

  // O(1), nothrow
  ReverseIterator rend() noexcept {
    return ReverseIterator(begin());
  }

  // O(1), nothrow
  ConstReverseIterator rend() const noexcept {
    return ConstReverseIterator(begin());
  }

  // O(1), nothrow
  Reference operator[](size_t index) {
    return *(data() + get_ind(index));
  }

  // O(1), nothrow
  ConstReference operator[](size_t index) const {
    return *(data() + get_ind(index));
  }

  // O(1), nothrow
  Reference back() {
    return data()[size() - 1];
  }

  // O(1), nothrow
  ConstReference back() const {
    return data()[size() - 1];
  }

  // O(1), nothrow
  Reference front() {
    return data()[0];
  }

  // O(1), nothrow
  ConstReference front() const {
    return data()[0];
  }

  // O(1), strong
  void push_back(const T& val) {
    push_back_impl(val);
  }

  // O(1), strong
  void push_back(T&& val) {
    push_back_impl(std::move(val));
  }

  // O(1), strong
  void push_front(const T& val) {
    push_front_impl(val);
  }

  // O(1), strong
  void push_front(T&& val) {
    push_front_impl(std::move(val));
  }

  // O(1), nothrow
  void pop_back() {
    data()[get_ind(--size_)].~T();
  }

  // O(1), nothrow
  void pop_front() {
    data()[get_ind(0)].~T();
    shift_ = (shift_ + 1) % capacity();
    --size_;
  }

  // O(n), strong
  void reserve(size_t desired_capacity) {
    if (desired_capacity > capacity()) {
      CircularBuffer tmp(desired_capacity);
      std::uninitialized_move_n(begin(), size(), tmp.begin());
      tmp.size_ += size();
      swap(tmp);
    }
  }

  // O(n), strong
  Iterator insert(ConstIterator pos, const T& val) {
    return insert_impl(pos, val);
  }

  // O(n), strong
  Iterator insert(ConstIterator pos, T&& val) {
    return insert_impl(pos, std::move(val));
  }

  // O(n), nothrow
  Iterator erase(ConstIterator pos) {
    return erase(pos, pos + 1);
  }

  // O(n), nothrow
  Iterator erase(ConstIterator first, ConstIterator last) {
    size_t start = first - begin();
    size_t cnt = last - first;
    if (first >= last) {
      return begin() + start;
    }
    if (start <= size() / 2) {
      std::rotate(begin(), begin() + start, begin() + start + cnt);
      for (size_t i = 0; i < cnt; i++) {
        pop_front();
      }
    } else {
      std::rotate(begin() + start, begin() + start + cnt, end());
      for (size_t i = 0; i < cnt; i++) {
        pop_back();
      }
    }
    return begin() + start;
  }

  // O(1), nothrow
  void swap(CircularBuffer& other) noexcept {
    using std::swap;
    swap(shift_, other.shift_);
    swap(size_, other.size_);
    swap(capacity_, other.capacity_);
    swap(data_, other.data_);
  }

  // O(1), nothrow
  friend void swap(CircularBuffer& first, CircularBuffer& second) noexcept {
    first.swap(second);
  }
};
} // namespace ct
