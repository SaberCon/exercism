defmodule Garden do
  @plants ~w[grass clover radishes violets]a
          |> Map.new(fn p -> {to_string(p) |> String.first() |> String.upcase(), p} end)

  @students ~w[alice bob charlie david eve fred ginny harriet ileana joseph kincaid larry]a

  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @students) do
    info_string
    |> String.split()
    |> Enum.map(&parse_row/1)
    |> Enum.zip_with(&merge_groups/1)
    |> then(&Enum.zip(Enum.sort(student_names), &1))
    |> Enum.into(Map.from_keys(student_names, {}))
  end

  defp parse_row(row) do
    row
    |> String.graphemes()
    |> Enum.chunk_every(2)
    |> Enum.map(&Enum.map(&1, fn cup -> @plants[cup] end))
  end

  defp merge_groups(groups) do
    groups |> List.flatten() |> List.to_tuple()
  end
end
