defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(%{exclude: exclude, size: size, sum: sum}) do
    1..9
    |> Enum.reject(&(&1 in exclude))
    |> do_combinations(size, sum)
    |> Enum.to_list()
  end

  defp do_combinations(_numbers, 0, 0), do: [[]]
  defp do_combinations(_numbers, size, _sum) when size <= 0, do: []
  defp do_combinations(_numbers, _size, sum) when sum <= 0, do: []
  defp do_combinations([], _size, _sum), do: []

  defp do_combinations([h | t], size, sum) do
    do_combinations(t, size - 1, sum - h)
    |> Stream.map(&[h | &1])
    |> Stream.concat(do_combinations(t, size, sum))
  end
end
