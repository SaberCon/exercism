defmodule StateOfTicTacToe do
  @doc """
  Determine the state a game of tic-tac-toe where X starts.
  """
  @spec game_state(board :: String.t()) :: {:ok, :win | :ongoing | :draw} | {:error, String.t()}
  def game_state(board) do
    {x_marks, o_marks, x_win, o_win} =
      board
      |> String.split()
      |> Enum.map(&String.graphemes/1)
      |> stats()

    with :ok <- validate_turn_order(x_marks, o_marks),
         :ok <- validate_end(x_marks, o_marks, x_win, o_win) do
      {:ok, do_game_state(x_marks, o_marks, x_win, o_win)}
    end
  end

  defp stats(board) do
    x_marks = marks(board, "X")
    o_marks = marks(board, "O")
    x_win = win?(board, "X")
    o_win = win?(board, "O")
    {x_marks, o_marks, x_win, o_win}
  end

  defp marks(board, mark) do
    board
    |> List.flatten()
    |> Enum.count(&(&1 == mark))
  end

  defp win?(board, mark) do
    win_by_row?(board, mark) or
      win_by_column?(board, mark) or
      win_by_diagonal?(board, mark)
  end

  defp win_by_row?(board, mark) do
    board
    |> Enum.any?(fn row -> Enum.all?(row, &(&1 == mark)) end)
  end

  defp win_by_column?(board, mark) do
    board
    |> Enum.zip_with(& &1)
    |> win_by_row?(mark)
  end

  defp win_by_diagonal?(board, mark) do
    indexed_board = board |> Enum.with_index()

    [
      indexed_board |> Enum.map(fn {row, i} -> Enum.at(row, i) end),
      indexed_board |> Enum.map(fn {row, i} -> Enum.at(row, 2 - i) end)
    ]
    |> Enum.any?(fn d -> d |> Enum.all?(&(&1 == mark)) end)
  end

  defp validate_turn_order(x_marks, o_marks) do
    cond do
      x_marks < o_marks -> {:error, "Wrong turn order: O started"}
      x_marks > o_marks + 1 -> {:error, "Wrong turn order: X went twice"}
      true -> :ok
    end
  end

  defp validate_end(x_marks, o_marks, x_win, o_win) do
    if (x_win and x_marks <= o_marks) or (o_win and x_marks > o_marks) do
      {:error, "Impossible board: game should have ended after the game was won"}
    else
      :ok
    end
  end

  defp do_game_state(x_marks, o_marks, x_win, o_win) do
    cond do
      x_win or o_win -> :win
      x_marks + o_marks == 9 -> :draw
      true -> :ongoing
    end
  end
end
