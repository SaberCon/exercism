defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number < 1 do
    {:error, "Classification is only possible for natural numbers."}
  end

  def classify(number) do
    case aliquot_sum(number) do
      ^number -> :perfect
      sum when sum > number -> :abundant
      sum when sum < number -> :deficient
    end
    |> then(&{:ok, &1})
  end

  defp aliquot_sum(number) do
    1..floor(:math.sqrt(number))
    |> Stream.filter(fn factor -> rem(number, factor) == 0 end)
    |> Stream.map(fn
      factor when factor == div(number, factor) -> factor
      factor -> factor + div(number, factor)
    end)
    |> Enum.sum()
    |> then(&(&1 - number))
  end
end
