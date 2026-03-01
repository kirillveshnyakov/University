#pragma once
#include "catch2/benchmark/detail/catch_complete_invoke.hpp"

#include <cstddef>
#include <type_traits>
#include <utility>

namespace ct::tl {

template <typename... Types>
struct TypeList;

template <typename Type, typename List>
struct contains_impl;

template <typename Type, template <typename...> class List, typename... Types>
struct contains_impl<Type, List<Types...>> {
  static constexpr bool value = (std::is_same_v<Type, Types> || ...);
};

template <typename Type, typename List>
inline constexpr bool contains = contains_impl<Type, List>::value;

template <typename Pair>
struct flip_impl;

template <template <typename...> class Pair, typename First, typename Second>
struct flip_impl<Pair<First, Second>> {
  using type = Pair<Second, First>;
};

template <typename Pair>
using flip = typename flip_impl<Pair>::type;

template <typename List>
struct flip_all_impl;

template <template <typename...> typename List, typename... Pairs>
struct flip_all_impl<List<Pairs...>> {
  using type = List<flip<Pairs>...>;
};

template <typename List>
using flip_all = typename flip_all_impl<List>::type;

template <typename Type, typename List>
struct index_of_unique_impl;

template <typename Type, template <typename...> class List, typename... Types>
struct index_of_unique_impl<Type, List<Types...>> {
  static constexpr std::size_t find_index() {
    std::size_t index = 0;
    const bool found = ((std::is_same_v<Type, Types> ? (++index, true) : (++index, false)) || ...);
    return found ? index - 1 : sizeof...(Types);
  }

  static constexpr std::size_t value = find_index();
};

template <typename Type, typename List>
inline constexpr std::size_t index_of_unique = index_of_unique_impl<Type, List>::value;

template <typename T>
struct identity {
  using type = T;
};

template <typename... Types1, typename... Types2>
identity<TypeList<Types1..., Types2...>> operator+(identity<TypeList<Types1...>>, identity<TypeList<Types2...>>);

template <typename... Lists>
struct concat_impl {
  using type = typename decltype((Lists{} + ...))::type;
};

template <typename... Lists>
using concat = typename concat_impl<identity<Lists>...>::type;

template <typename List1, typename List2>
struct update_list;

template <template <typename...> class List, typename... Types>
struct update_list<List<>, TypeList<Types...>> {
  using type = List<Types...>;
};

template <typename List>
struct flatten_impl {
  using type = TypeList<List>;
};

template <typename List>
struct flatten_impl_f;

template <template <typename...> class List, typename... Types>
struct flatten_impl<List<Types...>> {
  using type = concat<TypeList<>, typename flatten_impl<Types>::type...>;
};

template <template <typename...> class List, typename... Types>
struct flatten_impl_f<List<Types...>> {
  using type = typename update_list<List<>, concat<TypeList<>, typename flatten_impl<Types>::type...>>::type;
};

template <typename List>
using flatten = typename flatten_impl_f<List>::type;

template <typename List>
struct split;

template <template <typename...> class List, typename... Es>
struct split<List<Es...>> {
  using Tuple = std::tuple<Es...>;
  static constexpr std::size_t half = sizeof...(Es) / 2;

  template <std::size_t... Ind>
  static List<std::tuple_element_t<Ind, Tuple>...> get_first(std::index_sequence<Ind...>);

  template <std::size_t... Ind>
  static List<std::tuple_element_t<Ind + half, Tuple>...> get_second(std::index_sequence<Ind...>);

  using first = decltype(get_first(std::make_index_sequence<half>{}));
  using second = decltype(get_second(std::make_index_sequence<sizeof...(Es) - half>{}));
};

template <typename List1, typename List2, template <typename, typename> class Compare>
struct merge_impl;

template <
    template <typename, typename> class Compare,
    template <typename...> class List,
    typename E1,
    typename... Rest1,
    typename E2,
    typename... Rest2>
struct merge_impl<List<E1, Rest1...>, List<E2, Rest2...>, Compare> {
  using nextE = std::conditional_t<Compare<E1, E2>::value, E1, E2>;
  using List1 = std::conditional_t<Compare<E1, E2>::value, List<Rest1...>, List<E1, Rest1...>>;
  using List2 = std::conditional_t<Compare<E1, E2>::value, List<E2, Rest2...>, List<Rest2...>>;
  using type = concat<List<>, List<nextE>, typename merge_impl<List1, List2, Compare>::type>;
};

template <template <typename, typename> class Compare, template <typename...> class List, typename... Elements>
struct merge_impl<List<>, List<Elements...>, Compare> {
  using type = List<Elements...>;
};

template <template <typename, typename> class Compare, template <typename...> class List, typename... Elements>
struct merge_impl<List<Elements...>, List<>, Compare> {
  using type = List<Elements...>;
};

template <template <typename, typename> class Compare, template <typename...> class List>
struct merge_impl<List<>, List<>, Compare> {
  using type = List<>;
};

template <typename List1, typename List2, template <typename, typename> class Compare>
using merge = typename merge_impl<List1, List2, Compare>::type;

template <typename List, template <typename, typename> class Compare>
struct merge_sort_impl;

template <template <typename...> class List, typename... Types, template <typename, typename> class Compare>
struct merge_sort_impl<List<Types...>, Compare> {
  using L1 = typename merge_sort_impl<typename split<TypeList<Types...>>::first, Compare>::type;
  using L2 = typename merge_sort_impl<typename split<TypeList<Types...>>::second, Compare>::type;
  using type = typename update_list<List<>, merge<L1, L2, Compare>>::type;
};

template <template <typename...> class List, template <typename, typename> class Compare>
struct merge_sort_impl<List<>, Compare> {
  using type = List<>;
};

template <template <typename...> class List, typename El, template <typename, typename> class Compare>
struct merge_sort_impl<List<El>, Compare> {
  using type = List<El>;
};

template <typename List, template <typename, typename> class Compare>
using merge_sort = typename merge_sort_impl<List, Compare>::type;

} // namespace ct::tl
