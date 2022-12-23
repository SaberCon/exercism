defmodule BookStore do
  @price 800

  @discounts %{1 => 0, 2 => 0.05, 3 => 0.1, 4 => 0.2, 5 => 0.25}

  @typedoc "A book is represented by its number in the 5-book series"
  @type book :: 1 | 2 | 3 | 4 | 5

  @doc """
  Calculate lowest price (in cents) for a shopping basket containing books.
  """
  @spec total(basket :: [book]) :: integer
  def total(basket) do
    basket
    |> to_bundle_map()
    |> replace_53_with_44()
    |> Enum.map(&total_price/1)
    |> Enum.sum()
  end

  defp to_bundle_map(basket) do
    basket
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort(:desc)
    |> Enum.concat(List.duplicate(0, 6))
    |> Enum.take(6)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [freq1, freq2] -> freq1 - freq2 end)
    |> Enum.with_index(1)
    |> Map.new(fn {number, bundle} -> {bundle, number} end)
  end

  defp replace_53_with_44(bundle_map) do
    n = min(bundle_map[3], bundle_map[5])

    bundle_map
    |> Map.update!(3, &(&1 - n))
    |> Map.update!(5, &(&1 - n))
    |> Map.update!(4, &(&1 + 2 * n))
  end

  defp total_price({bundle, number}) do
    bundle * number * @price * (1 - @discounts[bundle])
  end
end
