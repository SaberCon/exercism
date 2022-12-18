defmodule Alphametics do
  @type puzzle :: binary
  @type solution :: %{required(?A..?Z) => 0..9}

  @doc """
  Takes an alphametics puzzle and returns a solution where every letter
  replaced by its number will make a valid equation. Returns `nil` when
  there is no valid solution to the given puzzle.

  ## Examples

    iex> Alphametics.solve("I + BB == ILL")
    %{?I => 1, ?B => 9, ?L => 0}

    iex> Alphametics.solve("A == B")
    nil
  """
  @spec solve(puzzle) :: solution | nil
  def solve(puzzle) do
    {words, result, letters, initials} = parse_equation(puzzle)

    letters
    |> solution_stream(0..9 |> Enum.to_list())
    |> Stream.reject(fn solution -> Enum.any?(initials, &(solution[&1] == 0)) end)
    |> Enum.find(&valid_solution?(&1, words, result))
  end

  defp parse_equation(puzzle) do
    [words, result] = puzzle |> String.split(" == ")
    words = words |> String.split(" + ") |> Enum.map(&to_charlist/1)
    result = result |> to_charlist()

    letters = [result | words] |> List.flatten() |> Enum.uniq()
    initials = [result | words] |> Enum.map(&hd/1) |> Enum.uniq()

    {words, result, letters, initials}
  end

  defp solution_stream([], _numbers), do: [%{}]
  defp solution_stream(_letters, []), do: []

  defp solution_stream([letter | rest], numbers) do
    numbers
    |> Stream.flat_map(fn n ->
      solution_stream(rest, numbers |> List.delete(n))
      |> Stream.map(&Map.put(&1, letter, n))
    end)
  end

  defp valid_solution?(solution, words, result) do
    words
    |> Enum.map(&convert_to_number(&1, solution))
    |> Enum.sum()
    |> Kernel.==(convert_to_number(result, solution))
  end

  defp convert_to_number(word, solution) do
    word
    |> Enum.map(fn d -> solution[d] end)
    |> Integer.undigits()
  end
end
