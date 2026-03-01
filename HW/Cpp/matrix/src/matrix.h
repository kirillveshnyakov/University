#pragma once

#include <algorithm>
#include <cassert>
#include <cstddef>
#include <iterator>
#include <numeric>
#include <type_traits>

namespace ct {

template <typename T>
class Matrix {
public:
  using ValueType = T;

  using Reference = T&;
  using ConstReference = const T&;

  using Pointer = T*;
  using ConstPointer = const T*;

private:
  template <typename R>
  class BasicColumnIterator {
  public:
    using reference = R&;
    using pointer = R*;
    using value_type = std::remove_const_t<R>;
    using difference_type = std::ptrdiff_t;
    using iterator_category = std::random_access_iterator_tag;

    BasicColumnIterator() = default;

    operator BasicColumnIterator<const R>() const {
      return BasicColumnIterator<const R>(_data, _cols, _offset);
    }

    reference operator*() const {
      return _data[_offset];
    }

    reference operator[](std::ptrdiff_t ind) const {
      return _data[_offset + ind * _cols];
    }

    pointer operator->() const {
      return _data + _offset;
    }

    BasicColumnIterator& operator++() {
      _data += _cols;
      return *this;
    }

    BasicColumnIterator& operator--() {
      _data -= _cols;
      return *this;
    }

    BasicColumnIterator operator++(int) {
      BasicColumnIterator result = *this;
      ++(*this);
      return result;
    }

    BasicColumnIterator operator--(int) {
      BasicColumnIterator result = *this;
      --(*this);
      return result;
    }

    BasicColumnIterator& operator+=(std::ptrdiff_t step) {
      _data += _cols * step;
      return *this;
    }

    BasicColumnIterator& operator-=(std::ptrdiff_t step) {
      _data -= _cols * step;
      return *this;
    }

    friend BasicColumnIterator operator+(const BasicColumnIterator& left, std::ptrdiff_t step) {
      BasicColumnIterator result = left;
      result._data += step * left._cols;
      return result;
    }

    friend BasicColumnIterator operator+(std::ptrdiff_t step, const BasicColumnIterator& right) {
      BasicColumnIterator result = right;
      result._data += step * right._cols;
      return result;
    }

    friend BasicColumnIterator operator-(const BasicColumnIterator& left, std::ptrdiff_t step) {
      BasicColumnIterator result = left;
      result._data -= step * left._cols;
      return result;
    }

    friend BasicColumnIterator operator-(std::ptrdiff_t step, const BasicColumnIterator& right) {
      BasicColumnIterator result = right;
      result._data -= step * right._cols;
      return result;
    }

    friend difference_type operator-(const BasicColumnIterator& lhs, const BasicColumnIterator& rhs) {
      return (lhs._data - rhs._data) / lhs._cols;
    }

    friend bool operator==(const BasicColumnIterator& lhs, const BasicColumnIterator& rhs) {
      return lhs._data == rhs._data;
    }

    friend bool operator!=(const BasicColumnIterator& lhs, const BasicColumnIterator& rhs) {
      return !(lhs == rhs);
    }

    friend bool operator<(const BasicColumnIterator& lhs, const BasicColumnIterator& rhs) {
      return lhs._data < rhs._data;
    }

    friend bool operator<=(const BasicColumnIterator& lhs, const BasicColumnIterator& rhs) {
      return (lhs < rhs) || (lhs == rhs);
    }

    friend bool operator>(const BasicColumnIterator& lhs, const BasicColumnIterator& rhs) {
      return !(lhs <= rhs);
    }

    friend bool operator>=(const BasicColumnIterator& lhs, const BasicColumnIterator& rhs) {
      return !(lhs < rhs);
    }

  private:
    pointer _data;
    difference_type _cols;
    difference_type _offset;

    BasicColumnIterator(pointer data, difference_type cols, difference_type col)
        : _data(data)
        , _cols(cols)
        , _offset(col) {}

    friend class Matrix;
  };

  template <typename It>
  class BasicView {
  public:
    BasicView(It begin, It end)
        : _begin(begin)
        , _end(end) {}

    It begin() const {
      return _begin;
    }

    It end() const {
      return _end;
    }

    BasicView& operator*=(ConstReference factor) & {
      std::transform(_begin, _end, _begin, [factor](auto& val) { return val * factor; });
      return *this;
    }

    const BasicView& operator*=(ConstReference factor) const& {
      std::transform(_begin, _end, _begin, [factor](auto& val) { return val * factor; });
      return *this;
    }

  private:
    It _begin;
    It _end;

    friend class Matrix;
  };

public:
  using Iterator = Pointer;
  using ConstIterator = ConstPointer;

  using RowIterator = Pointer;
  using ConstRowIterator = ConstPointer;

  using ColIterator = BasicColumnIterator<T>;
  using ConstColIterator = BasicColumnIterator<const T>;

  using RowView = BasicView<RowIterator>;
  using ConstRowView = BasicView<ConstRowIterator>;

  using ColView = BasicView<ColIterator>;
  using ConstColView = BasicView<ConstColIterator>;

public:
  Matrix() = default;

  Matrix(std::size_t rows, std::size_t cols) {
    if (rows > 0 && cols > 0) {
      _rows = rows;
      _cols = cols;
      _data = new T[_rows * _cols]{};
    }
  }

  template <size_t ROWS, size_t COLS>
  Matrix(const T (&arr)[ROWS][COLS])
      : Matrix(ROWS, COLS) {
    if (!empty()) {
      std::copy_n(&arr[0][0], _rows * _cols, data());
    }
  }

  Matrix(const Matrix& other)
      : _rows(other._rows)
      , _cols(other._cols) {
    if (!empty()) {
      _data = new T[_rows * _cols];
      std::copy(other.begin(), other.end(), begin());
    }
  }

  Matrix& operator=(const Matrix& other) & {
    if (this != &other) {
      Matrix tmp(other);
      swap(*this, tmp);
    }
    return *this;
  }

  ~Matrix() {
    delete[] _data;
  }

  friend void swap(Matrix& lhs, Matrix& rhs) {
    std::swap(lhs._rows, rhs._rows);
    std::swap(lhs._cols, rhs._cols);
    std::swap(lhs._data, rhs._data);
  }

  // Iterators

  Iterator begin() {
    return _data;
  }

  ConstIterator begin() const {
    return _data;
  }

  Iterator end() {
    return begin() + size();
  }

  ConstIterator end() const {
    return begin() + size();
  }

  RowIterator row_begin(size_t row) {
    assert(row < _rows);
    return begin() + row * _cols;
  }

  ConstRowIterator row_begin(size_t row) const {
    assert(row < _rows);
    return begin() + row * _cols;
  }

  RowIterator row_end(size_t row) {
    assert(row < _rows);
    return row_begin(row) + _cols;
  }

  ConstRowIterator row_end(size_t row) const {
    assert(row < _rows);
    return row_begin(row) + _cols;
  }

  ColIterator col_begin(size_t col) {
    assert(col < _cols);
    return ColIterator(begin(), _cols, col);
  }

  ConstColIterator col_begin(size_t col) const {
    assert(col < _cols);
    return ConstColIterator(begin(), _cols, col);
  }

  ColIterator col_end(size_t col) {
    assert(col < _cols);
    return ColIterator(end(), _cols, col);
  }

  ConstColIterator col_end(size_t col) const {
    assert(col < _cols);
    return ConstColIterator(end(), _cols, col);
  }

  // Views

  RowView row(size_t row) {
    return RowView(row_begin(row), row_end(row));
  }

  ConstRowView row(size_t row) const {
    return ConstRowView(row_begin(row), row_end(row));
  }

  ColView col(size_t col) {
    return ColView(col_begin(col), col_end(col));
  }

  ConstColView col(size_t col) const {
    return ConstColView(col_begin(col), col_end(col));
  }

  // Size

  size_t rows() const {
    return _rows;
  }

  size_t cols() const {
    return _cols;
  }

  size_t size() const {
    return rows() * cols();
  }

  bool empty() const {
    return size() == 0;
  }

  // Elements access

  Reference operator()(size_t row, size_t col) {
    assert(row < _rows);
    assert(col < _cols);
    return _data[get_ind(row, col)];
  }

  ConstReference operator()(size_t row, size_t col) const {
    assert(row < _rows);
    assert(col < _cols);
    return _data[get_ind(row, col)];
  }

  Pointer data() {
    return _data;
  }

  ConstPointer data() const {
    return _data;
  }

  // Comparison

  friend bool operator==(const Matrix& left, const Matrix& right) {
    return left.cols() == right.cols() && left.rows() == right.rows() &&
           std::equal(left.begin(), left.end(), right.begin());
  }

  friend bool operator!=(const Matrix& left, const Matrix& right) {
    return !(left == right);
  }

  // Arithmetic operations

  Matrix& operator+=(const Matrix& other) & {
    assert(_rows == other.rows());
    assert(_cols == other.cols());
    std::transform(begin(), end(), other.data(), begin(), std::plus<T>());
    return *this;
  }

  Matrix& operator-=(const Matrix& other) & {
    assert(_rows == other.rows());
    assert(_cols == other.cols());
    std::transform(begin(), end(), other.data(), begin(), std::minus<T>());
    return *this;
  }

  Matrix& operator*=(const Matrix& other) & {
    Matrix tmp = *this * other;
    swap(*this, tmp);
    return *this;
  }

  Matrix& operator*=(ConstReference factor) & {
    RowView view(data(), data() + size());
    view *= factor;
    return *this;
  }

  friend Matrix operator+(const Matrix& left, const Matrix& right) {
    Matrix tmp(left);
    tmp += right;
    return tmp;
  }

  friend Matrix operator-(const Matrix& left, const Matrix& right) {
    Matrix tmp(left);
    tmp -= right;
    return tmp;
  }

  friend Matrix operator*(const Matrix& left, const Matrix& right) {
    assert(left.cols() == right.rows());
    Matrix result(left.rows(), right.cols());
    for (size_t row = 0; row < result.rows(); ++row) {
      for (size_t col = 0; col < result.cols(); ++col) {
        ConstRowIterator ItR = left.begin() + left.cols() * row;
        ConstColIterator ItC(right.begin(), right.cols(), col);
        result(row, col) = std::inner_product(ItR, ItR + left.cols(), ItC, T(), std::plus<T>(), std::multiplies<T>());
      }
    }
    return result;
  }

  friend Matrix operator*(const Matrix& left, ConstReference right) {
    Matrix tmp(left);
    tmp *= right;
    return tmp;
  }

  friend Matrix operator*(ConstReference left, const Matrix& right) {
    Matrix tmp(right);
    tmp *= left;
    return tmp;
  }

private:
  size_t _rows = 0;
  size_t _cols = 0;
  Pointer _data = nullptr;

  size_t get_ind(const size_t row, const size_t col) const {
    return (row * _cols) + col;
  }
};

} // namespace ct
