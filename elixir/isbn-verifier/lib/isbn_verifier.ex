defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    normalize(isbn) |> valid?()
  end

  defp normalize(isbn), do: String.replace(isbn, "-", "")

  defp valid?(isbn), do: valid_format?(isbn) and valid_checksum?(isbn)

  defp valid_format?(isbn), do: String.match?(isbn, ~r/^\d{9}[\dX]$/)

  defp valid_checksum?(isbn) do
    isbn
    |> to_charlist()
    |> Enum.with_index()
    |> Enum.map(fn {d, i} -> num(d) * (10 - i) end)
    |> Enum.sum()
    |> rem(11) == 0
  end

  defp num(?X), do: 10
  defp num(d), do: d - ?0
end
