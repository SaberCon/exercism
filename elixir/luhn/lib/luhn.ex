defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    case normalize(number) do
      {:error, _} -> false
      {:ok, digits} -> valid_checksum?(digits)
    end
  end

  defp normalize(number) do
    digits = number |> String.replace(" ", "")

    cond do
      String.length(digits) <= 1 -> {:error, "number length is 1 or less"}
      digits =~ ~r/\D/ -> {:error, "number contains non-digit characters"}
      true -> {:ok, digits}
    end
  end

  defp valid_checksum?(number) do
    number
    |> String.reverse()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(fn
      {num, index} when rem(index, 2) == 0 -> num
      {num, _} when num < 5 -> num * 2
      {num, _} -> num * 2 - 9
    end)
    |> Enum.sum()
    |> then(fn sum -> rem(sum, 10) == 0 end)
  end
end
