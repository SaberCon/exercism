defmodule ComplexNumbers do
  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {float, float}

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: float
  def real({r, _}), do: r

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: float
  def imaginary({_, i}), do: i

  defp complex_number({r, i}), do: {r, i}
  defp complex_number(r), do: {r, 0}

  @doc """
  Multiply two complex numbers, or a real and a complex number
  """
  @spec mul(a :: complex | float, b :: complex | float) :: complex
  def mul(a, b) do
    {ar, ai} = complex_number(a)
    {br, bi} = complex_number(b)
    {ar * br - ai * bi, ai * br + ar * bi}
  end

  @doc """
  Add two complex numbers, or a real and a complex number
  """
  @spec add(a :: complex | float, b :: complex | float) :: complex
  def add(a, b) do
    {ar, ai} = complex_number(a)
    {br, bi} = complex_number(b)
    {ar + br, ai + bi}
  end

  defp negative({r, i}), do: {-r, -i}
  defp negative(r), do: -r

  @doc """
  Subtract two complex numbers, or a real and a complex number
  """
  @spec sub(a :: complex | float, b :: complex | float) :: complex
  def sub(a, b), do: add(a, negative(b))

  @doc """
  Divide two complex numbers, or a real and a complex number
  """
  @spec div(a :: complex | float, b :: complex | float) :: complex
  def div(a, b) do
    {ar, ai} = complex_number(a)
    {br, bi} = complex_number(b)
    divisor = br ** 2 + bi ** 2
    {(ar * br + ai * bi) / divisor, (ai * br - ar * bi) / divisor}
  end

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: float
  def abs({r, i}), do: :math.sqrt(r ** 2 + i ** 2)

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate({r, i}), do: {r, -i}

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp({r, i}), do: mul(:math.exp(r), {:math.cos(i), :math.sin(i)})
end
