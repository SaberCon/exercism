defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    plaintext
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]/, "")
    |> to_charlist()
    |> Stream.map(&substitute/1)
    |> Stream.chunk_every(5)
    |> Enum.map_join(" ", &to_string/1)
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    cipher
    |> String.downcase()
    |> String.replace(" ", "")
    |> to_charlist()
    |> Enum.map(&substitute/1)
    |> to_string()
  end

  defp substitute(code) when code in ?a..?z, do: ?a + 25 - (code - ?a)
  defp substitute(code) when code in ?0..?9, do: code
end
