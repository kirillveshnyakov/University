#pragma once

#include <limits>
#include <type_traits>

namespace ct {

template <typename T>
class BitSetReference {
  using Word = T;
  Word* word_;
  std::size_t index_;
  static constexpr std::size_t word_size = std::numeric_limits<Word>::digits;

  friend class BitSet;
  template <typename U>
  friend class BitSetView;
  template <typename U>
  friend class BitSetIterator;
  template <typename U>
  friend class BitSetReference;

  BitSetReference(Word* word, const std::size_t index)
      : word_(word)
      , index_(index) {}

public:
  BitSetReference() = delete;

  BitSetReference& operator=(const bool value) {
    Word x = static_cast<T>(1) << (word_size - 1 - index_);
    if (value) {
      *word_ |= x;
    } else {
      *word_ &= ~x;
    }
    return *this;
  }

  BitSetReference& flip() {
    static_assert(!std::is_const_v<T>);
    *word_ ^= static_cast<Word>(1) << (word_size - 1 - index_);
    return *this;
  }

  operator bool() const {
    return (*word_ & static_cast<Word>(1) << (word_size - 1 - index_)) != 0;
  }

  operator BitSetReference<const Word>() const {
    return BitSetReference<const Word>(word_, index_);
  }
};

} // namespace ct
