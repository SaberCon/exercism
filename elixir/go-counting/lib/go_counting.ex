defmodule GoCounting do
  @type position :: {integer, integer}
  @type owner :: %{owner: atom, territory: [position]}
  @type territories :: %{white: [position], black: [position], none: [position]}

  @doc """
  Return the owner and territory around a position
  """
  @spec territory(board :: String.t(), position :: position) ::
          {:ok, owner} | {:error, String.t()}
  def territory(board, pos) do
    board_map = to_board_map(board)

    case board_map[pos] do
      nil -> {:error, "Invalid coordinate"}
      "_" -> {:ok, do_territory(board_map, pos)}
      _ -> {:ok, %{owner: :none, territory: []}}
    end
  end

  defp to_board_map(board) do
    for {row, y} <- board |> String.split() |> Enum.with_index(),
        {stone, x} <- row |> String.graphemes() |> Enum.with_index(),
        into: %{} do
      {{x, y}, stone}
    end
  end

  defp do_territory(board_map, {x, y}) do
    case do_territory(board_map, {x, y}, {nil, []}) do
      {nil, positions} -> %{owner: :none, territory: positions |> Enum.sort()}
      {owner, positions} -> %{owner: owner, territory: positions |> Enum.sort()}
    end
  end

  defp do_territory(board_map, {x, y} = pos, {owner, positions}) do
    if pos in positions do
      {owner, positions}
    else
      case board_map[pos] do
        nil ->
          {owner, positions}

        "B" ->
          {update_owner(owner, :black), positions}

        "W" ->
          {update_owner(owner, :white), positions}

        "_" ->
          [{x, y - 1}, {x, y + 1}, {x - 1, y}, {x + 1, y}]
          |> Enum.reduce({owner, [pos | positions]}, fn p, acc ->
            do_territory(board_map, p, acc)
          end)
      end
    end
  end

  defp update_owner(nil, owner), do: owner
  defp update_owner(:none, _), do: :none
  defp update_owner(owner, owner), do: owner
  defp update_owner(_, _), do: :none

  @doc """
  Return all white, black and neutral territories
  """
  @spec territories(board :: String.t()) :: territories
  def territories(board) do
    board_map = to_board_map(board)

    board_map
    |> Enum.filter(fn {_pos, stone} -> stone == "_" end)
    |> Enum.map(fn {pos, _stone} -> pos end)
    |> Enum.group_by(fn pos -> do_territory(board_map, pos).owner end)
    |> Map.put_new(:none, [])
    |> Map.put_new(:black, [])
    |> Map.put_new(:white, [])
  end
end
