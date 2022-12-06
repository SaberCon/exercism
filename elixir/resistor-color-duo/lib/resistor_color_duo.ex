defmodule ResistorColorDuo do
  @band_colors [
    :black,
    :brown,
    :red,
    :orange,
    :yellow,
    :green,
    :blue,
    :violet,
    :grey,
    :white
  ]

  @doc """
  Calculate a resistance value from two colors
  """
  @spec value(colors :: [atom]) :: integer
  def value([color1, color2 | _]) do
    get_value(color1) * 10 + get_value(color2)
  end

  defp get_value(color) do
    Enum.find_index(@band_colors, fn c -> c == color end)
  end
end
