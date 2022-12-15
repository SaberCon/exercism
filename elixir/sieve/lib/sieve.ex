defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    2..limit//1
    |> Enum.to_list()
    |> sieve(limit, [])
  end

  defp sieve([], _limit, acc), do: acc |> Enum.reverse()

  defp sieve([prime | rest], limit, acc) do
    composites = prime..limit//prime |> Enum.to_list()
    sieve(rest -- composites, limit, [prime | acc])
  end
end
