defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    nums(MapSet.new(), limit, factors) |> Enum.sum()
  end

  defp nums(acc, _, []), do: acc

  defp nums(acc, limit, [0 | rest]), do: nums(acc, limit, rest)

  defp nums(acc, limit, [factor | rest]) do
    factor..(limit - 1)//factor
    |> MapSet.new()
    |> MapSet.union(acc)
    |> nums(limit, rest)
  end
end
