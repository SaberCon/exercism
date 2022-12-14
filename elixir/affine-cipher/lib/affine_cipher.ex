defmodule AffineCipher do
  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer, b: integer}

  @doc """
  Encode an encrypted message using a key
  """
  @spec encode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a, b: b}, message) do
    if Integer.gcd(a, 26) != 1 do
      {:error, "a and m must be coprime."}
    else
      message
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9]/, "")
      |> to_charlist()
      |> Enum.map(&do_encode(&1, a, b))
      |> Enum.chunk_every(5)
      |> Enum.map_join(" ", &to_string/1)
      |> then(&{:ok, &1})
    end
  end

  defp do_encode(letter, _, _) when letter in ?0..?9 do
    letter
  end

  defp do_encode(letter, a, b) when letter in ?a..?z do
    Integer.mod(a * (letter - ?a) + b, 26) + ?a
  end

  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key :: key(), encrypted :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a, b: b}, encrypted) do
    if Integer.gcd(a, 26) != 1 do
      {:error, "a and m must be coprime."}
    else
      encrypted
      |> String.replace(" ", "")
      |> to_charlist()
      |> Enum.map(&do_decode(&1, a, b))
      |> to_string()
      |> then(&{:ok, &1})
    end
  end

  defp do_decode(letter, _, _) when letter in ?0..?9 do
    letter
  end

  defp do_decode(letter, a, b) when letter in ?a..?z do
    Integer.mod(mmi(a, 26) * (letter - ?a - b), 26) + ?a
  end

  defp mmi(a, m) do
    Stream.iterate(1, fn n -> n + 1 end)
    |> Enum.find(fn n -> Integer.mod(a * n, m) == 1 end)
  end
end
