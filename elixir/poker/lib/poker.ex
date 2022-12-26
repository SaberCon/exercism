defmodule Poker do
  defguardp is_straight(a, b, c, d, e)
            when a - b == 1 and b - c == 1 and c - d == 1 and d - e == 1

  @doc """
  Given a list of poker hands, return a list containing the highest scoring hand.

  If two or more hands tie, return the list of tied hands in the order they were received.

  The basic rules and hand rankings for Poker can be found at:

  https://en.wikipedia.org/wiki/List_of_poker_hands

  For this exercise, we'll consider the game to be using no Jokers,
  so five-of-a-kind hands will not be tested. We will also consider
  the game to be using multiple decks, so it is possible for multiple
  players to have identical cards.

  Aces can be used in low (A 2 3 4 5) or high (10 J Q K A) straights, but do not count as
  a high card in the former case.

  For example, (A 2 3 4 5) will lose to (2 3 4 5 6).

  You can also assume all inputs will be valid, and do not need to perform error checking
  when parsing card values. All hands will be a list of 5 strings, containing a rank
  (or letter) for the rank, followed by the suit.

  Ranks (lowest to highest): 2 3 4 5 6 7 8 9 10 J Q K A
  Suits (order doesn't matter): C D H S

  Example hand: ~w(4S 5H 4C 5D 4H) # Full house, 5s over 4s
  """
  @spec best_hand(list(list(String.t()))) :: list(list(String.t()))
  def best_hand(hands) do
    hands
    |> Enum.group_by(fn hand -> hand |> normalize_hand() |> score end)
    |> Enum.max()
    |> elem(1)
  end

  defp normalize_hand(hand) do
    unsorted_hand = hand |> Enum.map(&normalize_card/1)
    freq = unsorted_hand |> Enum.frequencies_by(&elem(&1, 0))

    unsorted_hand |> Enum.sort_by(fn {rank, _suit} -> {freq[rank], rank} end, :desc)
  end

  defp normalize_card("A" <> suit), do: {14, suit}
  defp normalize_card("K" <> suit), do: {13, suit}
  defp normalize_card("Q" <> suit), do: {12, suit}
  defp normalize_card("J" <> suit), do: {11, suit}
  defp normalize_card("10" <> suit), do: {10, suit}
  defp normalize_card(<<num>> <> suit), do: {num - ?0, suit}

  # straight flush
  defp score([{14, suit}, {5, suit}, {4, suit}, {3, suit}, {2, suit}]), do: {9, 5}

  defp score([{a, suit}, {b, suit}, {c, suit}, {d, suit}, {e, suit}])
       when is_straight(a, b, c, d, e),
       do: {9, a}

  # four of a kind
  defp score([{a, _}, {a, _}, {a, _}, {a, _}, {b, _}]), do: {8, {a, b}}

  # full house
  defp score([{a, _}, {a, _}, {a, _}, {b, _}, {b, _}]), do: {7, {a, b}}

  # flush
  defp score([{a, suit}, {b, suit}, {c, suit}, {d, suit}, {e, suit}]), do: {6, {a, b, c, d, e}}

  # straight
  defp score([{14, _}, {5, _}, {4, _}, {3, _}, {2, _}]), do: {5, 5}

  defp score([{a, _}, {b, _}, {c, _}, {d, _}, {e, _}])
       when is_straight(a, b, c, d, e),
       do: {5, a}

  # three of a kind
  defp score([{a, _}, {a, _}, {a, _}, {b, _}, {c, _}]), do: {4, {a, b, c}}

  # two pair
  defp score([{a, _}, {a, _}, {b, _}, {b, _}, {c, _}]), do: {3, {a, b, c}}

  # one pair
  defp score([{a, _}, {a, _}, {b, _}, {c, _}, {d, _}]), do: {2, {a, b, c, d}}

  # high card
  defp score([{a, _}, {b, _}, {c, _}, {d, _}, {e, _}]), do: {1, {a, b, c, d, e}}
end
