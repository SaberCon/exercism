defmodule SecretHandshake do
  @actions [0b00001, 0b00010, 0b00100, 0b01000, 0b10000]

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    @actions
    |> Enum.filter(fn action -> Bitwise.band(action, code) == action end)
    |> Enum.reduce([], &execute/2)
  end

  defp execute(0b00001, acc), do: acc ++ ["wink"]
  defp execute(0b00010, acc), do: acc ++ ["double blink"]
  defp execute(0b00100, acc), do: acc ++ ["close your eyes"]
  defp execute(0b01000, acc), do: acc ++ ["jump"]
  defp execute(0b10000, acc), do: Enum.reverse(acc)
end
