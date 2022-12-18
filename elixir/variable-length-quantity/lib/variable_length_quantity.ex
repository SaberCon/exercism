defmodule VariableLengthQuantity do
  import Bitwise

  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers) do
    integers
    |> Enum.reduce(<<>>, fn i, acc -> acc <> do_encode(i, 0) end)
  end

  defp do_encode(0, 0), do: <<0>>
  defp do_encode(0, 1), do: <<>>

  defp do_encode(integer, b) do
    do_encode(integer >>> 7, 1) <> <<b::1, integer::7>>
  end

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes) do
    if match?(<<1::1, _::7>>, last_byte(bytes)) do
      {:error, "incomplete sequence"}
    else
      {:ok, do_decode(bytes, [0])}
    end
  end

  defp last_byte(<<>>), do: nil
  defp last_byte(bytes), do: binary_part(bytes, byte_size(bytes), -1)

  defp do_decode(<<>>, [0 | t]), do: t |> Enum.reverse()

  defp do_decode(<<1::1, i::7, rest::binary>>, [h | t]) do
    do_decode(rest, [(h <<< 7) + i | t])
  end

  defp do_decode(<<0::1, i::7, rest::binary>>, [h | t]) do
    do_decode(rest, [0, (h <<< 7) + i | t])
  end
end
