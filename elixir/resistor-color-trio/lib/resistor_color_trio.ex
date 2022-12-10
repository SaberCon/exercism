defmodule ResistorColorTrio do
  @color_bands ~w[black brown red orange yellow green blue violet grey white]a
               |> Enum.with_index()
               |> Map.new()

  @doc """
  Calculate the resistance value in ohm or kiloohm from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms}
  def label(colors) do
    colors
    |> ohms()
    |> format_ohms()
  end

  defp ohms(colors) do
    colors
    |> Enum.map(&@color_bands[&1])
    |> then(fn [d1, d2, d3] -> [d1, d2 | List.duplicate(0, d3)] end)
    |> Integer.undigits()
  end

  defp format_ohms(value) when value > 1000, do: {value / 1000, :kiloohms}
  defp format_ohms(value), do: {value, :ohms}
end
