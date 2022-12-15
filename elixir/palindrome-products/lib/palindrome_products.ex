defmodule PalindromeProducts do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1)

  def generate(max_factor, min_factor) when max_factor < min_factor do
    raise ArgumentError
  end

  def generate(max_factor, min_factor) do
    for first <- min_factor..max_factor,
        second <- first..max_factor,
        palindrome?(first * second) do
      [first, second]
    end
    |> Enum.group_by(&Enum.product/1)
  end

  defp palindrome?(number) do
    to_string(number)
    |> then(&(&1 == String.reverse(&1)))
  end
end
