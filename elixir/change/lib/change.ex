defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(coins, target) do
    case change_map(target, coins)[target] do
      nil -> {:error, "cannot change"}
      change -> {:ok, change}
    end
  end

  defp change_map(max_target, coins) do
    1..max_target//1 |> Enum.reduce(%{0 => []}, &change(&1, &2, coins))
  end

  defp change(target, changes, coins) do
    coins
    |> Enum.filter(&changes[target - &1])
    |> Enum.map(&[&1 | changes[target - &1]])
    |> Enum.min_by(&length/1, fn -> nil end)
    |> then(&Map.put(changes, target, &1))
  end
end
