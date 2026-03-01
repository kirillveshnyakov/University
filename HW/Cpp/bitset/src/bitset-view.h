#pragma once

#include "bitset-iterator.h"
#include "bitset-reference.h"

#include <algorithm>
#include <bit>
#include <functional>

namespace ct {

template <typename T>
class BitSetView {
public:
  using Value = bool;
  using Word = T;
  using Iterator = BitSetIterator<T>;
  using ConstIterator = BitSetIterator<const T>;
  using Reference = BitSetReference<T>;
  using ConstReference = BitSetReference<const T>;
  using View = BitSetView;
  using ConstView = BitSetView<const T>;
  static constexpr std::size_t NPOS = -1;

  template <typename U>
  friend class BitSetView;
  friend class BitSet;

private:
  Iterator begin_;
  Iterator end_;
  static constexpr std::size_t word_size = std::numeric_limits<Word>::digits;

  Word get_word(std::size_t ind) const {
    return begin().get_word(ind);
  }

  void put_word(std::size_t ind, Word word) const {
    begin().put_word(ind, word);
  }

  template <typename Func>
  void unary_func(const Func& func) const {
    std::size_t full_words = size() / word_size;
    std::size_t last_word_size = size() % word_size;
    for (std::size_t ind = 0; ind < full_words; ++ind) {
      Word value = func(get_word(ind));
      put_word(ind, value);
    }
    if (last_word_size != 0) {
      Word last_word = get_word(full_words);
      Word value = func(last_word);
      last_word &= ~0ULL >> last_word_size;
      value &= ~0ULL << (word_size - last_word_size);
      put_word(full_words, last_word | value);
    }
  }

  template <typename Func>
  void binary_func(const ConstView& other, const Func& func) const {
    std::size_t full_words = size() / word_size;
    std::size_t last_word_size = size() % word_size;
    for (std::size_t ind = 0; ind < full_words; ++ind) {
      Word word1 = get_word(ind);
      Word word2 = other.get_word(ind);
      put_word(ind, func(word1, word2));
    }
    if (last_word_size != 0) {
      Word last_word = get_word(full_words) & ~0ULL >> last_word_size;
      Word word1 = get_word(full_words) & ~0ULL << (word_size - last_word_size);
      Word word2 = other.get_word(full_words) & ~0ULL << (word_size - last_word_size);
      put_word(full_words, last_word | func(word1, word2));
    }
  }

  template <typename Func, typename Type>
  Type unary_func_check_bits(const Func& func, Type result, Type stop_result) const {
    std::size_t full_words = size() / word_size;
    std::size_t last_word_size = size() % word_size;
    for (std::size_t ind = 0; ind < full_words; ++ind) {
      Word word = get_word(ind);
      result = func(word, ~static_cast<Word>(0), result);
      if (result == stop_result) {
        return result;
      }
    }
    if (last_word_size != 0) {
      Word necessary_bits = ~static_cast<Word>(0) << (word_size - last_word_size);
      Word last_word = get_word(full_words) & necessary_bits;
      result = func(last_word, necessary_bits, result);
    }
    return result;
  }

public:
  BitSetView(const BitSetView& other) = default;

  BitSetView(Iterator begin, Iterator end)
      : begin_(begin)
      , end_(end) {}

  BitSetView& operator=(const BitSetView& other) = default;

  operator BitSetView<const T>() const {
    return BitSetView<const T>(begin(), end());
  }

  Reference operator[](std::ptrdiff_t index) const {
    return begin()[index];
  }

  Iterator begin() const {
    return begin_;
  }

  Iterator end() const {
    return end_;
  }

  std::size_t size() const {
    return end() - begin();
  }

  bool empty() const {
    return size() == 0;
  }

  bool all() const {
    return unary_func_check_bits(
        [](Word word, Word necessary_bits, bool result) { return result & (word == (~0ULL & necessary_bits)); },
        true,
        false
    );
  }

  bool any() const {
    return unary_func_check_bits(
        [](Word word, Word /*necessary_bits*/, bool result) { return result | (word != 0ULL); },
        false,
        true
    );
  }

  std::size_t count() const {
    return unary_func_check_bits(
        [](Word word, Word /*necessary_bits*/, std::size_t result) { return result + std::popcount(word); },
        static_cast<std::size_t>(0),
        NPOS
    );
  }

  BitSetView flip() const {
    unary_func([](Word word) { return ~word; });
    return *this;
  }

  BitSetView set() const {
    unary_func([](Word) { return ~0ULL; });
    return *this;
  }

  BitSetView reset() const {
    unary_func([](Word) { return 0ULL; });
    return *this;
  }

  BitSetView operator&=(const BitSetView<const T>& other) const {
    binary_func(other, std::bit_and<Word>());
    return *this;
  }

  BitSetView operator|=(const BitSetView<const T>& other) const {
    binary_func(other, std::bit_or<Word>());
    return *this;
  }

  BitSetView operator^=(const BitSetView<const T>& other) const {
    binary_func(other, std::bit_xor<Word>());
    return *this;
  }

  friend bool operator==(const BitSetView& left, const BitSetView& right) {
    if (left.size() != right.size()) {
      return false;
    }
    for (std::size_t ind = 0; ind < left.size() / word_size; ++ind) {
      if (left.get_word(ind) != right.get_word(ind)) {
        return false;
      }
    }
    if (left.size() % word_size != 0) {
      return left.get_word(left.size() / word_size) >> (word_size - left.size() % word_size) ==
             right.get_word(right.size() / word_size) >> (word_size - right.size() % word_size);
    }
    return true;
  }

  void swap(BitSetView& other) {
    std::swap(begin_, other.begin_);
    std::swap(end_, other.end_);
  }

  friend void swap(BitSetView& left, BitSetView& right) {
    left.swap(right);
  }

  BitSetView subview(std::size_t offset = 0, std::size_t count = NPOS) const {
    if (offset > size()) {
      return {end(), end()};
    }
    if (count <= size() - offset) {
      return {begin() + offset, begin() + offset + count};
    }
    return {begin() + offset, end()};
  }
};

} // namespace ct
