defmodule SecretHandshake do
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
    Integer.digits(code, 2)
    |> Enum.reverse()
    |> Stream.take(5)
    |> Stream.with_index()
    |> Stream.filter(fn {d, _} -> d == 1 end)
    |> Enum.reduce([], fn {_, i}, acc -> action(i, acc) end)
  end

  defp action(index, acc) do
    case index do
      0 -> acc ++ ["wink"]
      1 -> acc ++ ["double blink"]
      2 -> acc ++ ["close your eyes"]
      3 -> acc ++ ["jump"]
      4 -> Enum.reverse(acc)
    end
  end
end
