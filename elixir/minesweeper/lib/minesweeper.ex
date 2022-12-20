defmodule Minesweeper do
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]
  def annotate(board) do
    board = board |> Enum.map(&String.graphemes/1)
    mines = to_mines(board)
    rows = board |> length()
    cols = board |> Enum.at(0, []) |> length()

    build_board(rows, cols, mines)
  end

  defp to_mines(board) do
    for {row, i} <- Enum.with_index(board),
        {"*", j} <- Enum.with_index(row),
        into: MapSet.new() do
      {i, j}
    end
  end

  defp build_board(rows, cols, mines) do
    0..(rows - 1)//1
    |> Enum.map(fn row ->
      0..(cols - 1)//1
      |> Enum.map_join(&build_square({row, &1}, mines))
    end)
  end

  defp build_square(pos, mines) do
    if pos in mines do
      "*"
    else
      mine_count =
        pos
        |> adjacent_squares()
        |> Enum.count(&MapSet.member?(mines, &1))

      if mine_count == 0, do: " ", else: mine_count |> to_string()
    end
  end

  defp adjacent_squares({x, y}) do
    for nx <- (x - 1)..(x + 1),
        ny <- (y - 1)..(y + 1) do
      {nx, ny}
    end
  end
end
