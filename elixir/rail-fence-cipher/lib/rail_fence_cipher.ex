defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, rails) do
    str
    |> sort_string_by(rail_stream(rails))
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, rails) do
    1..String.length(str)
    |> sort_by(rail_stream(rails))
    |> then(&sort_string_by(str, &1))
  end

  defp rail_stream(rails) do
    1..rails//1
    |> Enum.concat((rails - 1)..2//-1)
    |> Stream.cycle()
  end

  defp sort_by(enumerable, indices) do
    enumerable
    |> Enum.zip(indices)
    |> Enum.sort_by(&elem(&1, 1))
    |> Enum.map(&elem(&1, 0))
  end

  defp sort_string_by(str, indices) do
    str
    |> String.graphemes()
    |> sort_by(indices)
    |> Enum.join()
  end
end
