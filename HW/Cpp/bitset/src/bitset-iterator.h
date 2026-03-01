#pragma once

#include "bitset-reference.h"

#include <iterator>

namespace ct {

template <typename T>
class BitSetIterator {
public:
  using iterator_category = std::random_access_iterator_tag;
  using value_type = bool;
  using difference_type = std::ptrdiff_t;
  using pointer = void;
  using reference = BitSetReference<T>;
  using Word = T;

  friend class BitSet;
  template <typename U>
  friend class BitSetView;
  template <typename U>
  friend class BitSetIterator;

private:
  Word* word_;
  std::size_t index_;
  static constexpr std::size_t word_size = std::numeric_limits<Word>::digits;

  Word* get_ptr() const {
    return word_;
  }

  std::size_t get_ind() const {
    return index_;
  }

  Word get_word(std::size_t ind) const {
    Word result = (*(word_ + ind) << index_) + (index_ == 0 ? 0 : *(word_ + ind + 1) >> (word_size - index_));
    return result;
  }

  void put_word(std::size_t ind, Word word) {
    *(word_ + ind) &= index_ == 0 ? 0 : ~0ULL << (word_size - index_);
    *(word_ + ind) |= word >> index_;
    if (index_ != 0) {
      *(word_ + ind + 1) <<= index_;
      *(word_ + ind + 1) >>= index_;
      *(word_ + ind + 1) |= word << (word_size - index_);
    }
  }

  BitSetIterator(Word* word, std::size_t index)
      : word_(word)
      , index_(index) {}

public:
  BitSetIterator() = default;
  BitSetIterator(const BitSetIterator& other) = default;
  BitSetIterator& operator=(const BitSetIterator& other) = default;

  operator BitSetIterator<const T>() const {
    return BitSetIterator<const T>(word_, index_);
  }

  reference operator*() const {
    return {word_, index_};
  }

  BitSetIterator& operator+=(const difference_type ind) {
    constexpr auto diff_word_size = static_cast<difference_type>(word_size);
    difference_type tmp = static_cast<difference_type>(index_) + ind;
    word_ += tmp / diff_word_size;
    if (tmp < 0 && tmp % diff_word_size != 0) {
      --word_;
    }
    index_ = (tmp % diff_word_size + diff_word_size) % diff_word_size;
    return *this;
  }

  BitSetIterator& operator-=(const difference_type ind) {
    return (*this += (-ind));
  }

  reference operator[](const difference_type ind) const {
    BitSetIterator tmp = *this;
    tmp += ind;
    return *tmp;
  }

  BitSetIterator& operator++() {
    index_++;
    if (index_ == word_size) {
      index_ = 0;
      ++word_;
    }
    return *this;
  }

  BitSetIterator operator++(int) {
    BitSetIterator result = *this;
    ++(*this);
    return result;
  }

  BitSetIterator& operator--() {
    if (index_ == 0) {
      index_ = word_size - 1;
      --word_;
    } else {
      --index_;
    }
    return *this;
  }

  BitSetIterator operator--(int) {
    BitSetIterator result = *this;
    --(*this);
    return result;
  }

  friend BitSetIterator operator+(const BitSetIterator& it, const difference_type ind) {
    BitSetIterator result = it;
    result += ind;
    return result;
  }

  friend BitSetIterator operator+(const difference_type ind, const BitSetIterator& it) {
    return it + ind;
  }

  friend BitSetIterator operator-(const BitSetIterator& it, const difference_type ind) {
    return it + (-ind);
  }

  friend difference_type operator-(const BitSetIterator& left, const BitSetIterator& right) {
    difference_type word_diff = left.word_ - right.word_;
    difference_type index_diff = static_cast<difference_type>(left.index_) - static_cast<difference_type>(right.index_);
    return (word_diff * static_cast<difference_type>(word_size)) + index_diff;
  }

  friend bool operator==(const BitSetIterator& left, const BitSetIterator& right) {
    return left.word_ == right.word_ && left.index_ == right.index_;
  }

  friend bool operator!=(const BitSetIterator& left, const BitSetIterator& right) {
    return !(left == right);
  }

  friend bool operator<(const BitSetIterator& left, const BitSetIterator& right) {
    return left.word_ < right.word_ || (left.word_ == right.word_ && left.index_ < right.index_);
  }

  friend bool operator>(const BitSetIterator& left, const BitSetIterator& right) {
    return right < left;
  }

  friend bool operator<=(const BitSetIterator& left, const BitSetIterator& right) {
    return !(right < left);
  }

  friend bool operator>=(const BitSetIterator& left, const BitSetIterator& right) {
    return !(left < right);
  }

  void swap(BitSetIterator& other) {
    std::swap(word_, other.word_);
    std::swap(index_, other.index_);
  }
};

} // namespace ct
