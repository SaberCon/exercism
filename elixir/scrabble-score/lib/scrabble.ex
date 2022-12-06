defmodule Scrabble do
  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer
  def score(word) do
    word
    |> String.upcase()
    |> to_charlist()
    |> Enum.map(&value/1)
    |> Enum.sum()
  end

  defp value(letter) do
    cond do
      letter in 'AEIOULNRST' -> 1
      letter in 'DG' -> 2
      letter in 'BCMP' -> 3
      letter in 'FHVWY' -> 4
      letter in 'K' -> 5
      letter in 'JX' -> 8
      letter in 'QZ' -> 10
      true -> 0
    end
  end
end
