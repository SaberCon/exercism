defmodule Yacht do
  @type category ::
          :ones
          | :twos
          | :threes
          | :fours
          | :fives
          | :sixes
          | :full_house
          | :four_of_a_kind
          | :little_straight
          | :big_straight
          | :choice
          | :yacht

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.
  """
  @spec score(category :: category(), dice :: [integer]) :: integer
  def score(:ones, dice), do: count_score(dice, 1)
  def score(:twos, dice), do: count_score(dice, 2)
  def score(:threes, dice), do: count_score(dice, 3)
  def score(:fours, dice), do: count_score(dice, 4)
  def score(:fives, dice), do: count_score(dice, 5)
  def score(:sixes, dice), do: count_score(dice, 6)

  def score(:full_house, dice) do
    case Enum.sort(dice) do
      [n, n, n, n, n] -> 0
      [n1, n1, n1, n2, n2] -> n1 * 3 + n2 * 2
      [n1, n1, n2, n2, n2] -> n1 * 2 + n2 * 3
      _ -> 0
    end
  end

  def score(:four_of_a_kind, dice) do
    case Enum.sort(dice) do
      [n1, n1, n1, n1, _] -> n1 * 4
      [_, n2, n2, n2, n2] -> n2 * 4
      _ -> 0
    end
  end

  def score(:little_straight, dice) do
    case Enum.sort(dice) do
      [1, 2, 3, 4, 5] -> 30
      _ -> 0
    end
  end

  def score(:big_straight, dice) do
    case Enum.sort(dice) do
      [2, 3, 4, 5, 6] -> 30
      _ -> 0
    end
  end

  def score(:choice, dice), do: Enum.sum(dice)

  def score(:yacht, dice) do
    case dice do
      [n, n, n, n, n] -> 50
      _ -> 0
    end
  end

  defp count_score(dice, number) do
    number * Enum.count(dice, fn n -> n == number end)
  end
end
