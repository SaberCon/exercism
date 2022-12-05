defmodule CollatzConjecture do
  import Integer, only: [is_even: 1, is_odd: 1]

  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input) when is_integer(input) and input > 0 do
    input
    |> Stream.iterate(fn
      n when is_odd(n) -> n * 3 + 1
      n when is_even(n) -> div(n, 2)
    end)
    |> Stream.take_while(fn n -> n > 1 end)
    |> Enum.count()
  end
end
