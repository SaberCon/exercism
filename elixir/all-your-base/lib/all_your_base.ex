defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """
  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(digits, input_base, output_base) do
    cond do
      output_base < 2 ->
        {:error, "output base must be >= 2"}

      input_base < 2 ->
        {:error, "input base must be >= 2"}

      Enum.any?(digits, fn d -> d < 0 or d >= input_base end) ->
        {:error, "all digits must be >= 0 and < input base"}

      true ->
        {:ok, do_convert(digits, input_base, output_base)}
    end
  end

  defp do_convert(digits, input_base, output_base) do
    digits
    |> to_decimal(input_base)
    |> from_decimal(output_base)
  end

  defp to_decimal(digits, base) do
    Enum.reduce(digits, 0, fn d, acc -> acc * base + d end)
  end

  defp from_decimal(0, _base), do: [0]

  defp from_decimal(num, base) do
    Stream.unfold(num, fn
      0 -> nil
      n -> {rem(n, base), div(n, base)}
    end)
    |> Enum.reverse()
  end
end
