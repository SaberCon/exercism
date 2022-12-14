defmodule FoodChain do
  @foods {
    {"fly", "I don't know why she swallowed the fly. Perhaps she'll die.\n"},
    {"spider", "It wriggled and jiggled and tickled inside her.\n"},
    {"bird", "How absurd to swallow a bird!\n"},
    {"cat", "Imagine that, to swallow a cat!\n"},
    {"dog", "What a hog, to swallow a dog!\n"},
    {"goat", "Just opened her throat and swallowed a goat!\n"},
    {"cow", "I don't know how she swallowed a cow!\n"},
    {"horse", "She's dead, of course!\n"}
  }

  @doc """
  Generate consecutive verses of the song 'I Know an Old Lady Who Swallowed a Fly'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    start..stop |> Enum.map_join("\n", &verse/1)
  end

  defp verse(n) when n == 1 or n == 8 do
    knowledge(n) <> comment(n)
  end

  defp verse(n) when n in 2..7 do
    knowledge(n) <> comment(n) <> swallow_chain(n) <> comment(1)
  end

  defp knowledge(n), do: "I know an old lady who swallowed a #{food(n)}.\n"

  defp swallow_chain(n), do: n..1 |> Enum.map_join(&swallow/1)

  defp swallow(1), do: ""

  defp swallow(3) do
    "She swallowed the #{food(3)} to catch the #{food(2)} " <>
      "that wriggled and jiggled and tickled inside her.\n"
  end

  defp swallow(n), do: "She swallowed the #{food(n)} to catch the #{food(n - 1)}.\n"

  defp food(n), do: @foods |> elem(n - 1) |> elem(0)

  defp comment(n), do: @foods |> elem(n - 1) |> elem(1)
end
