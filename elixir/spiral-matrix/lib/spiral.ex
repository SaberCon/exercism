defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(dimension), do: do_matrix(1, dimension, dimension)

  defp do_matrix(_, 0, _), do: []
  defp do_matrix(_, _, 0), do: []

  defp do_matrix(start, rows, cols) do
    [
      Enum.to_list(start..(start + cols - 1))
      | do_matrix(start + cols, cols, rows - 1) |> rotate_clockwise
    ]
  end

  defp rotate_clockwise(matrix) do
    Enum.zip_with(matrix, & &1)
    |> Enum.map(&Enum.reverse/1)
  end
end
