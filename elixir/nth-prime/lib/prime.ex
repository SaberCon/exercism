defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count > 0, do: do_nth(count, 3, [2])

  defp do_nth(count, _, primes) when length(primes) == count do
    hd(primes)
  end

  defp do_nth(count, num, primes) do
    if prime?(num, primes) do
      do_nth(count, num + 1, [num | primes])
    else
      do_nth(count, num + 1, primes)
    end
  end

  defp prime?(num, primes) do
    Enum.all?(primes, &(rem(num, &1) > 0))
  end
end
