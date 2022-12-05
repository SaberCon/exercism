defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    digits = Integer.digits(number)
    len = length(digits)

    digits
    |> Enum.reduce(0, fn d, acc -> acc + Integer.pow(d, len) end)
    |> Kernel.==(number)
  end
end
