defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) do
    ?A..(letter - 1)//1
    |> Enum.concat(letter..?A)
    |> Enum.map_join(&build_row(&1, ?A, letter))
  end

  defp build_row(letter, start_letter, end_letter) do
    first_half =
      <<letter>>
      |> String.pad_leading(end_letter - letter + 1)
      |> String.pad_trailing(end_letter - start_letter + 1)

    second_half =
      first_half
      |> String.reverse()
      |> String.slice(1..-1)

    first_half <> second_half <> "\n"
  end
end
