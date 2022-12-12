defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(_number_string, 0), do: 1

  def largest_product(_number_string, size) when size < 0 do
    raise ArgumentError
  end

  def largest_product(number_string, size) when byte_size(number_string) < size do
    raise ArgumentError
  end

  def largest_product(number_string, size) do
    number_string
    |> String.graphemes()
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(size, 1, :discard)
    |> Stream.map(&Enum.product/1)
    |> Enum.max()
  end
end
