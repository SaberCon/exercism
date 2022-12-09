defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num) do
    Stream.iterate([1], &next_row/1)
    |> Enum.take(num)
  end

  defp next_row(row) do
    row
    |> Enum.chunk_every(2, 1)
    |> Enum.map(&Enum.sum/1)
    |> List.insert_at(0, 1)
  end
end
