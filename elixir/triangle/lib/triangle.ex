defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) do
    case Enum.sort([a, b, c]) do
      [n, _, _] when n <= 0 -> {:error, "all side lengths must be positive"}
      [n1, n2, n3] when n1 + n2 < n3 -> {:error, "side lengths violate triangle inequality"}
      [n, n, n] -> {:ok, :equilateral}
      [_, n, n] -> {:ok, :isosceles}
      [n, n, _] -> {:ok, :isosceles}
      _ -> {:ok, :scalene}
    end
  end
end
