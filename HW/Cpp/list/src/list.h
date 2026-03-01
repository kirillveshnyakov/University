#pragma once

#include <cassert>
#include <cstddef>
#include <ios>
#include <iterator>

namespace ct {
template <typename T>
class List {
  class BaseNode {
  public:
    BaseNode* prev = nullptr;
    BaseNode* next = nullptr;

    BaseNode() = default;

    virtual ~BaseNode() {
      if (prev) {
        prev->next = next;
      }
      if (next) {
        next->prev = prev;
      }
    }
  };

  class Node : public BaseNode {
  public:
    T value;

    Node() = delete;

    ~Node() override = default;

    explicit Node(const T& value_)
        : value(value_) {}

    explicit Node(T&& value_)
        : value(std::move(value_)) {}

    Node(const T& value_, BaseNode* prevNode, BaseNode* nextNode)
        : value(value_) {
      this->prev = prevNode;
      this->next = nextNode;
    }

    Node(T&& value_, BaseNode* prevNode, BaseNode* nextNode)
        : value(std::move(value_)) {
      this->prev = prevNode;
      this->next = nextNode;
    }
  };

public:
  template <bool isConst>
  class ListIterator {
    using base_node_pointer = BaseNode*;
    using node_pointer = Node*;
    base_node_pointer node;

    explicit ListIterator(base_node_pointer node_)
        : node(node_) {}

    base_node_pointer get_node() const {
      return node;
    }

  public:
    friend class List;

    template <bool otherIsConst>
    friend class ListIterator;

    using iterator_category = std::bidirectional_iterator_tag;
    using value_type = T;
    using difference_type = std::ptrdiff_t;
    using reference = std::conditional_t<isConst, const T&, T&>;
    using pointer = std::conditional_t<isConst, const T*, T*>;

    ListIterator() = default;

    explicit ListIterator(std::nullptr_t) = delete;

    ~ListIterator() = default;

    operator ListIterator<true>() const {
      return ListIterator<true>(node);
    }

    reference operator*() const {
      assert(node->next != nullptr);
      return static_cast<node_pointer>(node)->value;
    }

    pointer operator->() const {
      assert(node->next != nullptr);
      return &static_cast<node_pointer>(node)->value;
    }

    ListIterator& operator++() {
      node = node->next;
      return *this;
    }

    ListIterator operator++(int) {
      ListIterator tmp = *this;
      ++(*this);
      return tmp;
    }

    ListIterator& operator--() {
      node = node->prev;
      return *this;
    }

    ListIterator operator--(int) {
      ListIterator tmp = *this;
      --(*this);
      return tmp;
    }

    template <bool otherIsConst>
    bool operator==(const ListIterator<otherIsConst>& other) const {
      return node == other.get_node();
    }

    template <bool otherIsConst>
    bool operator!=(const ListIterator<otherIsConst>& other) const {
      return !(*this == other);
    }
  };

  using ValueType = T;

  using Reference = T&;
  using ConstReference = const T&;

  using Pointer = T*;
  using ConstPointer = const T*;

  using Iterator = ListIterator<false>;
  using ConstIterator = ListIterator<true>;

  using ReverseIterator = std::reverse_iterator<Iterator>;
  using ConstReverseIterator = std::reverse_iterator<ConstIterator>;

private:
  BaseNode end_node;
  mutable std::size_t cached_size = 0;
  mutable bool is_valid_size = false;

public:
  // O(1), nothrow
  friend void swap(List& left, List& right) noexcept {
    using std::swap;
    swap(left.cached_size, right.cached_size);
    swap(left.end_node.next, right.end_node.next);
    swap(left.end_node.prev, right.end_node.prev);
    if (left.end_node.next != &right.end_node) {
      left.end_node.next->prev = &left.end_node;
      left.end_node.prev->next = &left.end_node;
    } else {
      left.end_node.next = &left.end_node;
      left.end_node.prev = &left.end_node;
    }
    if (right.end_node.next != &left.end_node) {
      right.end_node.next->prev = &right.end_node;
      right.end_node.prev->next = &right.end_node;
    } else {
      right.end_node.next = &right.end_node;
      right.end_node.prev = &right.end_node;
    }
  }

  // O(1), nothrow
  List() noexcept {
    end_node.next = &end_node;
    end_node.prev = &end_node;
  }

  // O(n), strong
  List(const List& other)
      : List() {
    ConstIterator it = other.begin();
    try {
      for (; it != other.end(); ++it) {
        push_back(*it);
      }
    } catch (...) {
      clear();
      throw;
    }
  }

  // O(1), nothrow
  List(List&& other) noexcept
      : List() {
    swap(*this, other);
  }

  // O(n), strong
  template <std::input_iterator InputIt>
  List(InputIt first, InputIt last) : List() {
    try {
      for (; first != last; ++first) {
        push_back(*first);
      }
    } catch (...) {
      clear();
      throw;
    }
  }

  // O(n), strong
  List& operator=(const List& other) {
    if (this != &other) {
      List tmp(other);
      swap(*this, tmp);
    }
    return *this;
  }

  // O(this->size()), nothrow
  List& operator=(List&& other) noexcept {
    List tmp(std::move(other));
    swap(*this, tmp);
    return *this;
  }

  // O(n), nothrow
  ~List() noexcept {
    clear();
  }

  // O(1), nothrow
  bool empty() const noexcept {
    return size() == 0;
  }

  // O(n), nothrow
  size_t size() const noexcept {
    if (!is_valid_size) {
      cached_size = std::distance(begin(), end());
      is_valid_size = true;
    }
    return cached_size;
  }

  // O(1), nothrow
  Reference front() {
    return *begin();
  }

  // O(1), nothrow
  ConstReference front() const {
    return *begin();
  }

  // O(1), nothrow
  Reference back() {
    return *--end();
  }

  // O(1), nothrow
  ConstReference back() const {
    return *--end();
  }

  // O(1), strong
  void push_front(const T& value) {
    insert(begin(), value);
  }

  // O(1), strong
  void push_front(T&& value) {
    insert(begin(), std::move(value));
  }

  // O(1), strong
  void push_back(const T& value) {
    insert(end(), value);
  }

  // O(1), strong
  void push_back(T&& value) {
    insert(end(), std::move(value));
  }

  // O(1), nothrow
  void pop_front() {
    if (!empty()) {
      erase(begin());
    }
  }

  // O(1), nothrow
  void pop_back() {
    if (!empty()) {
      erase(--end());
    }
  }

  // O(1), nothrow
  Iterator begin() noexcept {
    return Iterator(end_node.next);
  }

  // O(1), nothrow
  ConstIterator begin() const noexcept {
    return ConstIterator(end_node.next);
  }

  // O(1), nothrow
  Iterator end() noexcept {
    return Iterator(&end_node);
  }

  // O(1), nothrow
  ConstIterator end() const noexcept {
    return ConstIterator(const_cast<BaseNode*>(&end_node));
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

  // O(n), nothrow
  void clear() noexcept {
    while (!empty()) {
      pop_back();
    }
  }

  // O(1), strong
  Iterator insert(ConstIterator pos, const T& value) {
    Node* new_node = nullptr;
    try {
      new_node = new Node(value);
    } catch (...) {
      delete new_node;
      throw;
    }
    new_node->prev = pos.get_node()->prev;
    new_node->next = pos.get_node();
    pos.get_node()->prev->next = new_node;
    pos.get_node()->prev = new_node;
    cached_size++;
    return Iterator(new_node);
  }

  // O(1), strong
  Iterator insert(ConstIterator pos, T&& value) {
    Node* new_node = nullptr;
    try {
      new_node = new Node(std::move(value));
    } catch (...) {
      delete new_node;
      throw;
    }
    new_node->prev = pos.get_node()->prev;
    new_node->next = pos.get_node();
    pos.get_node()->prev->next = new_node;
    pos.get_node()->prev = new_node;
    cached_size++;
    return Iterator(new_node);
  }

  // O(last - first), strong
  template <std::input_iterator InputIt>
  Iterator insert(ConstIterator pos, InputIt first, InputIt last) {
    if (first == last) {
      return Iterator(pos.get_node());
    }
    List tmp(first, last);
    Iterator result = tmp.begin();
    splice(pos, tmp, tmp.begin(), tmp.end());
    return result;
  }

  // O(1), nothrow
  Iterator erase(ConstIterator pos) noexcept {
    if (pos == end()) {
      return end();
    }
    pos.get_node()->prev->next = pos.get_node()->next;
    pos.get_node()->next->prev = pos.get_node()->prev;
    Iterator result = Iterator(pos.get_node()->next);
    delete static_cast<Node*>(pos.get_node());
    cached_size--;
    return result;
  }

  // O(last - first), nothrow
  Iterator erase(ConstIterator first, ConstIterator last) noexcept {
    while (first != last) {
      first = erase(first);
    }
    return Iterator(last.get_node());
  }

  // O(1), nothrow
  void splice(ConstIterator pos, List& other, ConstIterator first, ConstIterator last) noexcept {
    if (first == last) {
      return;
    }

    BaseNode* first_node = first.get_node();
    BaseNode* last_node = last.get_node();
    BaseNode* pos_node = pos.get_node();
    BaseNode* first_prev = first_node->prev;
    BaseNode* last_prev = last_node->prev;
    BaseNode* pos_prev = pos_node->prev;

    first_prev->next = last_node;
    last_node->prev = first_prev;

    pos_prev->next = first_node;
    first_node->prev = pos_prev;

    last_prev->next = pos_node;
    pos.node->prev = last_prev;

    is_valid_size = false;
    other.is_valid_size = false;
  }
};
} // namespace ct
