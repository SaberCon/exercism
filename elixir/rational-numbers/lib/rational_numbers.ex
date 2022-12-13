defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({a1, a2}, {b1, b2}) do
    {a1 * b2 + b1 * a2, a2 * b2}
    |> reduce()
  end

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract({a1, a2}, {b1, b2}) do
    add({a1, a2}, {-b1, b2})
  end

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({a1, a2}, {b1, b2}) do
    {a1 * b1, a2 * b2}
    |> reduce()
  end

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(a :: rational, b :: rational) :: rational
  def divide_by({a1, a2}, {b1, b2}) when b1 != 0 do
    multiply({a1, a2}, {b2, b1})
  end

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({a1, a2}) do
    {Kernel.abs(a1), Kernel.abs(a2)}
    |> reduce()
  end

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational({a1, a2}, n) when n >= 0 do
    {Integer.pow(a1, n), Integer.pow(a2, n)}
    |> reduce()
  end

  def pow_rational({a1, a2}, n) when n < 0 do
    pow_rational({a2, a1}, -n)
  end

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, {n1, n2}) do
    x ** (n1 / n2)
  end

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce({a1, a2}) when a2 < 0 do
    reduce({-a1, -a2})
  end

  def reduce({a1, a2}) do
    gcd = Integer.gcd(a1, a2)
    {a1 / gcd, a2 / gcd}
  end
end
