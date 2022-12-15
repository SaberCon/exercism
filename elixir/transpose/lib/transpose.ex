defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples

    iex> Transpose.transpose("ABC\\nDE")
    "AD\\nBE\\nC"

    iex> Transpose.transpose("AB\\nDEF")
    "AD\\nBE\\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> List.foldr([], &add_to_columns/2)
    |> Enum.join("\n")
  end

  defp add_to_columns(chars, []), do: chars

  defp add_to_columns([], columns), do: add_to_columns([" "], columns)

  defp add_to_columns([char | rest_chars], [column | rest_columns]) do
    [char <> column | add_to_columns(rest_chars, rest_columns)]
  end
end
