defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(""), do: ""

  def encode(str) do
    text = normalize(str)
    cols = get_cols(text)
    do_encode(text, cols)
  end

  defp normalize(str) do
    str
    |> String.downcase()
    |> String.replace(~r/\W/, "")
  end

  defp get_cols(text) do
    text
    |> String.length()
    |> :math.sqrt()
    |> ceil()
  end

  defp do_encode(text, cols) do
    text
    |> String.graphemes()
    |> Enum.chunk_every(cols, cols, Stream.cycle([" "]))
    |> Enum.zip_with(&Enum.join/1)
    |> Enum.join(" ")
  end
end
