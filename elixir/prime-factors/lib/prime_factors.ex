defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(1), do: []
  def factors_for(number), do: factors(number, 2, [])

  defp factors(number, factor, acc) do
    cond do
      number < factor * factor -> [number | acc] |> Enum.reverse()
      rem(number, factor) == 0 -> factors(div(number, factor), factor, [factor | acc])
      true -> factors(number, factor + 1, acc)
    end
  end
end
