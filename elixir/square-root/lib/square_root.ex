defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand), do: square_root(radicand, 1, radicand)

  defp square_root(_radicand, mi, ma) when mi > ma do
    raise ArgumentError
  end

  defp square_root(radicand, mi, ma) do
    mid = floor((mi + ma) / 2)

    case mid * mid do
      ^radicand -> mid
      square when square > radicand -> square_root(radicand, mi, mid - 1)
      square when square < radicand -> square_root(radicand, mid + 1, ma)
    end
  end
end
