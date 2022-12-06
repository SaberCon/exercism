defmodule Pangram do
  @alphabet MapSet.new(?a..?z)

  @doc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox jumps over the lazy dog")
      true

  """
  @spec pangram?(String.t()) :: boolean
  def pangram?(sentence) do
    sentence
    |> String.downcase()
    |> to_charlist()
    |> Stream.filter(fn c -> c in @alphabet end)
    |> Stream.uniq()
    |> Enum.count() == MapSet.size(@alphabet)
  end
end
