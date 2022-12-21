defmodule Rectangles do
  @doc """
  Count the number of ASCII rectangles.
  """
  @spec count(input :: String.t()) :: integer
  def count(input) do
    {diagram, rows, cols} = parse(input)
    rectangles(diagram, rows, cols)
  end

  defp parse(input) do
    diagram =
      input
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)

    {diagram, diagram |> length(), diagram |> Enum.at(0, []) |> length()}
  end

  defp rectangles(diagram, rows, cols) do
    for i1 <- 0..(rows - 1)//1,
        j1 <- 0..(cols - 1)//1,
        i2 <- (i1 + 1)..(rows - 1)//1,
        j2 <- (j1 + 1)..(cols - 1)//1,
        rectangles?(i1, j1, i2, j2, diagram) do
      :ok
    end
    |> Enum.count()
  end

  defp rectangles?(i1, j1, i2, j2, diagram) do
    connected?({i1, j1}, {i1, j2}, diagram) and
      connected?({i1, j1}, {i2, j1}, diagram) and
      connected?({i1, j2}, {i2, j2}, diagram) and
      connected?({i2, j1}, {i2, j2}, diagram)
  end

  defp connected?({i, j1}, {i, j2}, diagram) do
    diagram
    |> Enum.at(i)
    |> Enum.slice(j1..j2)
    |> Enum.all?(&(&1 == "-" or &1 == "+"))
  end

  defp connected?({i1, j}, {i2, j}, diagram) do
    diagram
    |> Enum.slice(i1..i2)
    |> Enum.all?(fn row -> Enum.at(row, j) |> then(&(&1 == "|" or &1 == "+")) end)
  end
end
