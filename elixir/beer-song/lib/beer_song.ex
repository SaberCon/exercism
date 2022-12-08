defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(number) when number in 0..99 do
    """
    #{String.capitalize(bottles(number))} of beer on the wall, #{bottles(number)} of beer.
    #{action(number)}, #{bottles(Integer.mod(number - 1, 100))} of beer on the wall.
    """
  end

  defp bottles(0), do: "no more bottles"
  defp bottles(1), do: "1 bottle"
  defp bottles(number), do: "#{number} bottles"

  defp action(0), do: "Go to the store and buy some more"
  defp action(1), do: "Take it down and pass it around"
  defp action(_), do: "Take one down and pass it around"

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    range |> Enum.map_join("\n", &verse/1)
  end
end
