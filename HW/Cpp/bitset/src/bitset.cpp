#include "bitset.h"

#include <ostream>

namespace ct {

size_t BitSet::evaluate_capacity(const size_t size) const {
  return (size / word_size + (size % word_size ? 1 : 0) + 1) * word_size;
}

BitSet::BitSet()
    : size_{0}
    , data_{nullptr} {}

BitSet::BitSet(const std::size_t size)
    : size_{size}
    , data_(nullptr) {
  if (size == 0) {
    return;
  }
  data_ = new Word[evaluate_capacity(size_) / word_size]{};
}

BitSet::BitSet(const std::size_t size, const bool value)
    : BitSet(size) {
  if (value) {
    set();
  }
}

BitSet::BitSet(const BitSet& other)
    : BitSet(other.subview()) {}

BitSet::BitSet(std::string_view str)
    : BitSet(str.size(), false) {
  if (str.empty()) {
    return;
  }
  Word shift = 0;
  auto str_it = str.begin();
  for (std::size_t ind = 0; ind < (evaluate_capacity(size_) / word_size); ++ind) {
    for (shift = word_size; str_it < str.end() && shift > 0; ++str_it, --shift) {
      if (*str_it == '1') {
        data_[ind] += static_cast<Word>(1) << (shift - 1);
      }
    }
  }
}

BitSet::BitSet(const ConstView& other)
    : BitSet(other.size(), false) {
  *this |= other;
}

BitSet::BitSet(ConstIterator first, ConstIterator last)
    : BitSet(last - first, false) {
  *this |= ConstView(first, last);
}

BitSet& BitSet::operator=(const BitSet& other) & {
  if (this == &other) {
    return *this;
  }
  BitSet tmp(other);
  swap(tmp);
  return *this;
}

BitSet& BitSet::operator=(std::string_view str) & {
  BitSet tmp(str);
  swap(tmp);
  return *this;
}

BitSet& BitSet::operator=(const ConstView& other) & {
  BitSet tmp(other);
  swap(tmp);
  return *this;
}

BitSet::~BitSet() {
  delete[] data_;
}

void BitSet::swap(BitSet& other) {
  std::swap(data_, other.data_);
  std::swap(size_, other.size_);
}

std::size_t BitSet::size() const {
  return size_;
}

bool BitSet::empty() const {
  return size() == 0;
}

BitSet::Reference BitSet::operator[](const std::size_t index) {
  return {data_ + (index / word_size), index % word_size};
}

BitSet::ConstReference BitSet::operator[](const std::size_t index) const {
  return {data_ + (index / word_size), index % word_size};
}

BitSet::Iterator BitSet::begin() {
  return {data_, 0};
}

BitSet::ConstIterator BitSet::begin() const {
  return {data_, 0};
}

BitSet::Iterator BitSet::end() {
  return {data_ + (size() / word_size), size() % word_size};
}

BitSet::ConstIterator BitSet::end() const {
  return {data_ + (size() / word_size), size() % word_size};
}

BitSet& BitSet::operator&=(const ConstView& other) & {
  subview() &= other;
  return *this;
}

BitSet& BitSet::operator|=(const ConstView& other) & {
  subview() |= other;
  return *this;
}

BitSet& BitSet::operator^=(const ConstView& other) & {
  subview() ^= other;
  return *this;
}

BitSet& BitSet::operator<<=(std::size_t count) & {
  if (evaluate_capacity(size()) != evaluate_capacity(size() + count)) {
    BitSet result(size() + count, false);
    View view = result.subview(0, size());
    view |= subview();
    swap(result);
  } else if (count > 0) {
    size_ += count;
    View view = subview(size());
    view.reset();
  }
  return *this;
}

BitSet& BitSet::operator>>=(std::size_t count) & {
  const size_t new_size = count >= size() ? 0 : size() - count;
  if (evaluate_capacity(new_size) != evaluate_capacity(size())) {
    BitSet result(new_size, false);
    View view = result.subview();
    view |= subview(0, new_size);
    swap(result);
  } else {
    View view = subview(new_size);
    view.reset();
    size_ = new_size;
  }
  return *this;
}

BitSet& BitSet::flip() & {
  subview().flip();
  return *this;
}

BitSet& BitSet::set() & {
  subview().set();
  return *this;
}

BitSet& BitSet::reset() & {
  subview().reset();
  return *this;
}

bool BitSet::all() const {
  return subview().all();
}

bool BitSet::any() const {
  return subview().any();
}

std::size_t BitSet::count() const {
  return subview().count();
}

BitSet::operator ConstView() const {
  return {begin(), end()};
}

BitSet::operator View() {
  return {begin(), end()};
}

BitSet::View BitSet::subview(std::size_t offset, std::size_t count) {
  return View(begin(), end()).subview(offset, count);
}

BitSet::ConstView BitSet::subview(std::size_t offset, std::size_t count) const {
  return ConstView(begin(), end()).subview(offset, count);
}

bool operator!=(const BitSet& left, const BitSet& right) {
  return !(left == right);
}

void swap(BitSet& lhs, BitSet& rhs) {
  lhs.swap(rhs);
}

BitSet operator&(const BitSet::ConstView& lhs, const BitSet::ConstView& rhs) {
  BitSet tmp(lhs);
  tmp &= rhs;
  return tmp;
}

BitSet operator|(const BitSet::ConstView& lhs, const BitSet::ConstView& rhs) {
  BitSet tmp(lhs);
  tmp |= rhs;
  return tmp;
}

BitSet operator^(const BitSet::ConstView& lhs, const BitSet::ConstView& rhs) {
  BitSet tmp(lhs);
  tmp ^= rhs;
  return tmp;
}

BitSet operator~(const BitSet::ConstView& bs) {
  BitSet tmp(bs);
  tmp.flip();
  return tmp;
}

BitSet operator<<(const BitSet::ConstView& bs, std::size_t count) {
  BitSet tmp(bs);
  tmp <<= count;
  return tmp;
}

BitSet operator>>(const BitSet::ConstView& bs, std::size_t count) {
  BitSet tmp(bs);
  tmp >>= count;
  return tmp;
}

std::string to_string(const BitSet::ConstView& bsv) {
  std::string result;
  for (const BitSet::ConstReference bit : bsv) {
    result += bit ? '1' : '0';
  }
  return result;
}

std::string to_string(const BitSet& bs) {
  return to_string(bs.subview());
}

std::ostream& operator<<(std::ostream& out, const BitSet::ConstView& bsv) {
  for (const BitSet::ConstReference bit : bsv) {
    out << bit;
  }
  return out;
}

} // namespace ct
