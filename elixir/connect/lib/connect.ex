defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for(board) do
    board = board |> Enum.map(&String.graphemes/1)
    rotated_board = board |> Enum.zip_with(& &1)

    cond do
      connected?(board, "O") -> :white
      connected?(rotated_board, "X") -> :black
      true -> :none
    end
  end

  defp connected?(board, stone) do
    target = length(board) - 1
    path = to_path(board, stone)

    hd(board)
    |> Enum.with_index()
    |> Enum.filter(fn {s, _} -> s == stone end)
    |> Enum.map(fn {_, j} -> {0, j} end)
    |> Enum.any?(&do_connected?(&1, target, path))
  end

  defp to_path(board, stone) do
    for {row, i} <- Enum.with_index(board),
        {^stone, j} <- Enum.with_index(row),
        into: MapSet.new() do
      {i, j}
    end
  end

  defp do_connected?({target, _}, target, _), do: true

  defp do_connected?(pos, target, path) do
    rest_path = MapSet.delete(path, pos)

    neighbors(pos)
    |> Enum.filter(&MapSet.member?(rest_path, &1))
    |> Enum.any?(&do_connected?(&1, target, rest_path))
  end

  defp neighbors({x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y + 1}
    ]
  end
end
