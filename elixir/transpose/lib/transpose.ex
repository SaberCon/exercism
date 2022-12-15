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
    |> pad_short_rows()
    |> rows_to_columns()
    |> Enum.map_join("\n", &normalize_column/1)
  end

  defp pad_short_rows(rows) do
    max_length =
      rows
      |> Enum.map(&String.length/1)
      |> Enum.max()

    rows
    |> Enum.map(&String.pad_trailing(&1, max_length, "🥵"))
  end

  defp normalize_column(rows) do
    rows
    |> String.trim_trailing("🥵")
    |> String.replace("🥵", " ")
  end

  defp rows_to_columns(rows) do
    rows
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip_with(&Enum.join/1)
  end
end
