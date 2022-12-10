defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""

  def recite(strings) do
    strings
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(fn [w1, w2] -> "For want of a #{w1} the #{w2} was lost." end)
    |> Stream.concat(["And all for the want of a #{hd(strings)}.\n"])
    |> Enum.join("\n")
  end
end
