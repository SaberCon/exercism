defmodule WordSearch do
  defmodule Location do
    defstruct [:from, :to]

    @type t :: %Location{
            from: %{row: integer, column: integer},
            to: %{row: integer, column: integer}
          }
  end

  @doc """
  Find the start and end positions of words in a grid of letters.
  Row and column positions are 1 indexed.
  """
  @spec search(grid :: String.t(), words :: [String.t()]) :: %{String.t() => nil | Location.t()}
  def search(grid, words) do
    char_map = to_char_map(grid)
    words |> Map.new(fn word -> {word, do_search(char_map, word)} end)
  end

  defp to_char_map(grid) do
    for {row, i} <- grid |> String.split() |> Enum.with_index(),
        {char, j} <- row |> String.graphemes() |> Enum.with_index(),
        into: %{} do
      {{i, j}, char}
    end
  end

  defp do_search(char_map, word) do
    with nil <- search_word(char_map, word) do
      search_word_reversed(char_map, word)
    end
  end

  defp search_word(char_map, word) do
    char_map
    |> Map.keys()
    |> Stream.map(&match_location(char_map, word, &1))
    |> Enum.find(& &1)
  end

  defp search_word_reversed(char_map, word) do
    case search_word(char_map, String.reverse(word)) do
      nil -> nil
      %Location{from: from, to: to} -> %Location{from: to, to: from}
    end
  end

  defp match_location(char_map, word, from) do
    [{0, 1}, {1, 0}, {1, 1}, {1, -1}]
    |> Stream.map(&match_location(char_map, word, from, &1))
    |> Enum.find(& &1)
  end

  defp match_location(char_map, word, {i, j} = from, {di, dj}) do
    coordinates =
      0..(String.length(word) - 1)
      |> Enum.map(fn n -> {i + di * n, j + dj * n} end)

    case Enum.map_join(coordinates, &char_map[&1]) do
      ^word -> location(from, coordinates |> List.last())
      _ -> nil
    end
  end

  defp location({i1, j1}, {i2, j2}) do
    %Location{from: %{row: i1 + 1, column: j1 + 1}, to: %{row: i2 + 1, column: j2 + 1}}
  end
end
