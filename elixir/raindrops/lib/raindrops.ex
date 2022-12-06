defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    sounds =
      [{3, "Pling"}, {5, "Plang"}, {7, "Plong"}]
      |> Enum.map_join(&output(number, &1))

    if sounds == "", do: to_string(number), else: sounds
  end

  defp output(number, {factor, sound}) do
    if rem(number, factor) == 0, do: sound, else: ""
  end
end
