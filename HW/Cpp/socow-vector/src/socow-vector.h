#pragma once

#include <cstddef>
#include <memory>
#include <type_traits>

namespace ct {

template <typename T, std::size_t SMALL_SIZE>
class SocowVector {
public:
  static_assert(std::is_copy_constructible_v<T>, "T must have a copy constructor");
  static_assert(std::is_nothrow_move_constructible_v<T>, "T must have a non-throwing move constructor");
  static_assert(std::is_copy_assignable_v<T>, "T must have a copy assignment operator");
  static_assert(std::is_nothrow_move_assignable_v<T>, "T must have a non-throwing move assignment operator");
  static_assert(std::is_nothrow_swappable_v<T>, "T must have a non-throwing swap");

  static_assert(SMALL_SIZE > 0, "SMALL_SIZE must be positive");

  using ValueType = T;
  using Reference = T&;
  using ConstReference = const T&;
  using Iterator = T*;
  using ConstIterator = const T*;
  using Pointer = T*;
  using ConstPointer = const T*;

private:
  struct Buffer {
    std::size_t capacity{0};
    std::size_t ref_count = 1;
    ValueType data[0];
  };

  Buffer* alloc_buffer(std::size_t capacity_) {
    auto new_buffer = static_cast<Buffer*>(operator new(
        sizeof(Buffer) + (sizeof(T) * capacity_),
        static_cast<std::align_val_t>(alignof(T))
    ));
    new_buffer->capacity = capacity_;
    new_buffer->ref_count = 1;
    return new_buffer;
  }

  static void clear_data(Pointer buffer, const std::size_t count) {
    for (std::size_t i = count; i > 0; --i) {
      buffer[i - 1].~T();
    }
  }

  std::size_t size_;
  bool is_small_;

  union {
    ValueType static_buffer_[SMALL_SIZE];
    Buffer* dynamic_buffer_;
  };

  ConstIterator const_data() const {
    return is_small() ? static_buffer_ : dynamic_buffer_->data;
  }

  void ref_inc() {
    ++dynamic_buffer_->ref_count;
  }

  void ref_dec() {
    --dynamic_buffer_->ref_count;
  }

  bool is_single() {
    return is_small() || (!is_small() && dynamic_buffer_->ref_count == 1);
  }

  explicit SocowVector(const std::size_t capacity)
      : size_{0} {
    if (capacity > SMALL_SIZE) {
      dynamic_buffer_ = alloc_buffer(capacity);
      is_small_ = false;
    } else {
      is_small_ = true;
    }
  }

  void unshare() {
    if (!is_single()) {
      Buffer* new_buffer = alloc_buffer(capacity());
      try {
        std::uninitialized_copy_n(const_data(), size(), new_buffer->data);
      } catch (...) {
        operator delete(new_buffer, static_cast<std::align_val_t>(alignof(T)));
        throw;
      }
      ref_dec();
      dynamic_buffer_ = new_buffer;
    }
  }

  void change_capacity(const size_t new_capacity) {
    SocowVector tmp(new_capacity);
    if (is_single()) {
      std::uninitialized_move_n(data(), size(), tmp.data());
    } else {
      std::uninitialized_copy_n(const_data(), size(), tmp.data());
    }
    tmp.size_ = size();
    swap(tmp);
  }

public:
  SocowVector()
      : size_{0}
      , is_small_{true} {}

  SocowVector(const SocowVector& other)
      : size_{other.size()}
      , is_small_{other.is_small()} {
    if (is_small()) {
      std::uninitialized_copy_n(other.const_data(), size(), static_buffer_);
    } else {
      dynamic_buffer_ = other.dynamic_buffer_;
      ref_inc();
    }
  }

  SocowVector(SocowVector&& other) noexcept
      : size_{0}
      , is_small_{true} {
    swap(other);
  }

  SocowVector& operator=(const SocowVector& other) {
    if (&other == this) {
      return *this;
    }
    SocowVector tmp(other);
    clear();
    swap(tmp);
    return *this;
  }

  SocowVector& operator=(SocowVector&& other) noexcept {
    if (&other == this) {
      return *this;
    }
    clear();
    swap(other);
    return *this;
  }

  ~SocowVector() {
    if (is_single()) {
      clear_data(data(), size());
      if (!is_small()) {
        operator delete(dynamic_buffer_, static_cast<std::align_val_t>(alignof(T)));
      }
    } else {
      ref_dec();
    }
  }

  void swap(SocowVector& other) noexcept {
    if (this == &other) {
      return;
    }
    if (is_small() == other.is_small()) {
      if (is_small()) {
        std::size_t i = 0;
        while (i < size() && i < other.size()) {
          std::swap(data()[i], other.data()[i]);
          ++i;
        }
        Iterator data1 = (size() >= other.size()) ? data() : other.data();
        Iterator data2 = (size() >= other.size()) ? other.data() : data();
        const std::size_t data_size = (size() >= other.size()) ? size() : other.size();
        std::uninitialized_move_n(data1 + i, data_size - i, data2 + i);
        std::destroy_n(data1 + i, data_size - i);
      } else {
        std::swap(dynamic_buffer_, other.dynamic_buffer_);
      }
    } else {
      auto static_buffer_1 = is_small() ? static_buffer_ : other.static_buffer_;
      auto static_buffer_2 = !is_small() ? static_buffer_ : other.static_buffer_;
      std::size_t buffer_size = is_small() ? size() : other.size();
      Buffer* tmp = is_small() ? other.dynamic_buffer_ : dynamic_buffer_;
      std::uninitialized_move_n(static_buffer_1, buffer_size, static_buffer_2);
      std::destroy_n(static_buffer_1, buffer_size);
      (is_small() ? dynamic_buffer_ : other.dynamic_buffer_) = tmp;
    }
    std::swap(size_, other.size_);
    std::swap(is_small_, other.is_small_);
  }

  std::size_t size() const {
    return size_;
  }

  std::size_t capacity() const {
    return is_small() ? SMALL_SIZE : dynamic_buffer_->capacity;
  }

  bool empty() const {
    return size() == 0;
  }

  bool is_small() const {
    return is_small_;
  }

  Reference operator[](std::size_t index) {
    return data()[index];
  }

  ConstReference operator[](std::size_t index) const {
    return data()[index];
  }

  Reference front() {
    return data()[0];
  }

  ConstReference front() const {
    return data()[0];
  }

  Reference back() {
    return data()[size() - 1];
  }

  ConstReference back() const {
    return data()[size() - 1];
  }

  Iterator data() {
    if (is_small()) {
      return static_buffer_;
    }
    unshare();
    return dynamic_buffer_->data;
  }

  ConstIterator data() const {
    return const_data();
  }

  Iterator begin() {
    return data();
  }

  ConstIterator begin() const {
    return const_data();
  }

  Iterator end() {
    return data() + size();
  }

  ConstIterator end() const {
    return const_data() + size();
  }

  void clear() {
    if (is_single()) {
      clear_data(data(), size());
      size_ = 0;
    } else {
      ref_dec();
      size_ = 0;
      is_small_ = true;
      dynamic_buffer_ = nullptr;
    }
  }

  void reserve(const std::size_t new_capacity) {
    if (new_capacity > capacity()) {
      change_capacity(new_capacity);
    }
    if (is_single() || new_capacity <= size()) {
      return;
    }
    if (new_capacity > SMALL_SIZE) {
      unshare();
      return;
    }
    change_capacity(new_capacity);
  }

  void shrink_to_fit() {
    if (!is_small() && size() < capacity()) {
      change_capacity(size());
    }
  }

  void push_back(const ValueType& value) {
    push_back_impl(value);
  }

  void push_back(ValueType&& value) {
    push_back_impl(std::move(value));
  }

  void pop_back() {
    erase(const_data() + size() - 1);
  }

  Iterator insert(ConstIterator pos, const ValueType& value) {
    return insert_impl(pos, value);
  }

  Iterator insert(ConstIterator pos, ValueType&& value) {
    return insert_impl(pos, std::move(value));
  }

  Iterator erase(ConstIterator pos) {
    return erase(pos, pos + 1);
  }

  Iterator erase(ConstIterator first, ConstIterator last) {
    std::size_t start_ind = first - const_data();
    std::size_t end_ind = last - const_data();
    std::size_t count = last - first;
    if (is_single()) {
      for (std::size_t i = start_ind; i < size() - count; ++i) {
        data()[i] = std::move(data()[i + count]);
      }
      clear_data(end() - count, count);
      size_ -= count;
    } else {
      SocowVector tmp(capacity());
      for (std::size_t i = 0; i < start_ind; ++i) {
        tmp.push_back(const_data()[i]);
      }
      for (std::size_t i = end_ind; i < size(); ++i) {
        tmp.push_back(const_data()[i]);
      }
      swap(tmp);
    }
    return begin() + start_ind;
  }

private:
  template <typename U>
  void push_back_impl(U&& value) {
    if (size() < capacity()) {
      new (data() + size()) T(std::forward<U>(value));
      ++size_;
      return;
    }
    SocowVector tmp(capacity() * 2 + 1);
    new (tmp.data() + size()) T(std::forward<U>(value));
    try {
      if (is_single()) {
        for (std::size_t i = 0; i < size(); ++i) {
          tmp.push_back(std::move(data()[i]));
        }
      } else {
        for (std::size_t i = 0; i < size(); ++i) {
          tmp.push_back(const_data()[i]);
        }
      }
    } catch (...) {
      tmp.data()[size()].~T();
      throw;
    }
    ++tmp.size_;
    swap(tmp);
  }

  template <typename U>
  Iterator insert_impl(ConstIterator pos, U&& value) {
    size_t ind = pos - const_data();
    push_back(std::forward<U>(value));
    for (std::size_t i = size() - 1; i > ind; --i) {
      std::swap(data()[i], data()[i - 1]);
    }
    return begin() + ind;
  }
};

} // namespace ct
