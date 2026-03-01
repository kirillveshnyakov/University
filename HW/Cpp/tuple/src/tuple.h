#pragma once

#include <cstddef>
#include <utility>

namespace ct {

template <std::size_t Ind, typename T>
class Element {
public:
  static constexpr size_t ind = Ind;
  T value;
};

template <typename... T>
class TupleImpl;

template <std::size_t... Ind, typename... Types>
class TupleImpl<std::index_sequence<Ind...>, Types...> : public Element<Ind, Types>... {
public:
  TupleImpl()
      : Element<Ind, Types>()... {}

  template <typename... UTypes>
  explicit TupleImpl(UTypes&&... args)
      : Element<Ind, Types>(std::forward<UTypes>(args))... {}
};

template <typename... Types>
class Tuple : public TupleImpl<std::make_index_sequence<sizeof...(Types)>, Types...> {
public:
  Tuple()
    requires (std::is_default_constructible_v<Types> && ...)
      : TupleImpl<std::make_index_sequence<sizeof...(Types)>, Types...>() {}

  template <typename... UTypes>
  explicit Tuple(UTypes&&... args)
    requires (std::is_convertible_v<UTypes, Types> && ...)
      : TupleImpl<std::make_index_sequence<sizeof...(Types)>, Types...>(std::forward<UTypes>(args)...) {}
};

// deduction guide to aid CTAD
template <typename... Types>
Tuple(Types...) -> Tuple<Types...>;

template <typename... Types>
Tuple<std::decay_t<Types>...> make_tuple(Types&&... args) {
  return Tuple<std::decay_t<Types>...>(std::forward<Types>(args)...);
}

// -------------------------------------------------------------------------------------------------------

template <typename T>
inline constexpr std::size_t tuple_size = 0;

template <typename... Types>
inline constexpr std::size_t tuple_size<Tuple<Types...>> = sizeof...(Types);

// -------------------------------------------------------------------------------------------------------

template <std::size_t N, typename T>
struct tuple_element_impl {
  template <typename Type>
  static Type f(Element<N, Type>*);

  using type = decltype(f(static_cast<T*>(nullptr)));
};

template <std::size_t N, typename T>
using tuple_element = typename tuple_element_impl<N, T>::type;

// -------------------------------------------------------------------------------------------------------

template <std::size_t N, typename... Types>
tuple_element<N, Tuple<Types...>>& get(Tuple<Types...>& t) noexcept {
  using type = tuple_element<N, Tuple<Types...>>;
  return static_cast<Element<N, type>&>(t).value;
}

template <std::size_t N, typename... Types>
tuple_element<N, Tuple<Types...>>&& get(Tuple<Types...>&& t) noexcept {
  using type = tuple_element<N, Tuple<Types...>>;
  return std::move(static_cast<Element<N, type>&&>(t).value);
}

template <std::size_t N, typename... Types>
const tuple_element<N, Tuple<Types...>>& get(const Tuple<Types...>& t) noexcept {
  using type = tuple_element<N, Tuple<Types...>>;
  return static_cast<const Element<N, type>&>(t).value;
}

template <std::size_t N, typename... Types>
const tuple_element<N, Tuple<Types...>>&& get(const Tuple<Types...>&& t) noexcept {
  using type = tuple_element<N, Tuple<Types...>>;
  return std::move(static_cast<const Element<N, type>&&>(t).value);
}

// -------------------------------------------------------------------------------------------------------

template <typename Type, typename T>
struct type_index_impl {
  template <std::size_t N>
  static Element<N, Type> f(Element<N, Type>*);

  static constexpr size_t ind = decltype(f(static_cast<T*>(nullptr)))::ind;
};

template <typename Type, typename T>
static constexpr size_t type_index = type_index_impl<Type, T>::ind;

// -------------------------------------------------------------------------------------------------------

template <typename T, typename... Types>
T& get(Tuple<Types...>& t) noexcept {
  static constexpr size_t N = type_index<T, Tuple<Types...>>;
  return static_cast<Element<N, T>&>(t).value;
}

template <typename T, typename... Types>
T&& get(Tuple<Types...>&& t) noexcept {
  static constexpr size_t N = type_index<T, Tuple<Types...>>;
  return std::move(static_cast<Element<N, T>&&>(t).value);
}

template <typename T, typename... Types>
const T& get(const Tuple<Types...>& t) noexcept {
  static constexpr size_t N = type_index<T, Tuple<Types...>>;
  return static_cast<const Element<N, T>&>(t).value;
}

template <typename T, typename... Types>
const T&& get(const Tuple<Types...>&& t) noexcept {
  static constexpr size_t N = type_index<T, Tuple<Types...>>;
  return std::move(static_cast<const Element<N, T>&&>(t).value);
}

// -------------------------------------------------------------------------------------------------------

template <std::size_t ind, typename... TTypes, typename... UTypes>
std::partial_ordering compare(const Tuple<TTypes...>& lhs, const Tuple<UTypes...>& rhs) {
  if constexpr (ind == sizeof...(TTypes)) {
    return std::partial_ordering::equivalent;
  } else {
    if (const std::partial_ordering c = get<ind>(lhs) <=> get<ind>(rhs); c != std::partial_ordering::equivalent) {
      return c;
    }
    return compare<ind + 1>(lhs, rhs);
  }
}

template <typename... TTypes, typename... UTypes>
decltype(auto) operator<=>(const Tuple<TTypes...>& lhs, const Tuple<UTypes...>& rhs) {
  return compare<0>(lhs, rhs);
}

template <typename... TTypes, typename... UTypes>
bool operator==(const Tuple<TTypes...>& lhs, const Tuple<UTypes...>& rhs) {
  return compare<0>(lhs, rhs) == std::partial_ordering::equivalent;
}

// -------------------------------------------------------------------------------------------------------

template <typename... Tuples>
struct concat;

template <>
struct concat<> {
  using type = Tuple<>;
};

template <typename... Types1>
struct concat<Tuple<Types1...>> {
  using type = Tuple<Types1...>;
};

template <typename... Types1, typename... Types2>
struct concat<Tuple<Types1...>, Tuple<Types2...>> {
  using type = Tuple<Types1..., Types2...>;
};

template <typename... Types1, typename... Types2, typename... Rest>
struct concat<Tuple<Types1...>, Tuple<Types2...>, Rest...> {
  using type = typename concat<Tuple<Types1..., Types2...>, Rest...>::type;
};

// -------------------------------------------------------------------------------------------------------

template <std::size_t ind, typename Tuple1, typename... Tuples>
decltype(auto) get_element(Tuple1&& t1, Tuples&&... ts) {
  if constexpr (ind < tuple_size<std::decay_t<Tuple1>>) {
    return get<ind>(std::forward<Tuple1>(t1));
  } else {
    return get_element<ind - tuple_size<std::decay_t<Tuple1>>>(std::forward<Tuples>(ts)...);
  }
}

template <typename U, typename... Tuples>
struct tuple_cat_impl;

template <std::size_t... inds, typename... Tuples>
struct tuple_cat_impl<std::index_sequence<inds...>, Tuples...> {
  using tuple_type = typename concat<std::decay_t<Tuples>...>::type;

  static decltype(auto) concat_tuples(Tuples&&... args) {
    return tuple_type(get_element<inds>(std::forward<Tuples>(args)...)...);
  }
};

template <typename... Tuples>
decltype(auto) tuple_cat(Tuples&&... args) {
  constexpr std::size_t size = (tuple_size<std::decay_t<Tuples>> + ... + 0);
  return tuple_cat_impl<std::make_index_sequence<size>, Tuples...>::concat_tuples(std::forward<Tuples>(args)...);
}

} // namespace ct
