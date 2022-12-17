defmodule OcrNumbers do
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(input) do
    with :ok <- validate_lines(input),
         :ok <- validate_columns(input) do
      {:ok, do_convert(input)}
    end
  end

  defp validate_lines(input) do
    case length(input) do
      len when rem(len, 4) == 0 -> :ok
      _ -> {:error, "invalid line count"}
    end
  end

  defp validate_columns(input) do
    case input |> Enum.map(&String.length/1) |> Enum.min_max() do
      {len, len} when rem(len, 3) == 0 -> :ok
      _ -> {:error, "invalid column count"}
    end
  end

  defp do_convert(input) do
    input
    |> Enum.chunk_every(4)
    |> Enum.map_join(",", &convert_line/1)
  end

  defp convert_line(line) do
    line
    |> Enum.map(&split_string(&1, 3))
    |> Enum.zip_with(&convert_cell/1)
    |> Enum.join()
  end

  defp convert_cell(cell) do
    case cell do
      [
        " _ ",
        "| |",
        "|_|",
        "   "
      ] ->
        "0"

      [
        "   ",
        "  |",
        "  |",
        "   "
      ] ->
        "1"

      [
        " _ ",
        " _|",
        "|_ ",
        "   "
      ] ->
        "2"

      [
        " _ ",
        " _|",
        " _|",
        "   "
      ] ->
        "3"

      [
        "   ",
        "|_|",
        "  |",
        "   "
      ] ->
        "4"

      [
        " _ ",
        "|_ ",
        " _|",
        "   "
      ] ->
        "5"

      [
        " _ ",
        "|_ ",
        "|_|",
        "   "
      ] ->
        "6"

      [
        " _ ",
        "  |",
        "  |",
        "   "
      ] ->
        "7"

      [
        " _ ",
        "|_|",
        "|_|",
        "   "
      ] ->
        "8"

      [
        " _ ",
        "|_|",
        " _|",
        "   "
      ] ->
        "9"

      _ ->
        "?"
    end
  end

  defp split_string(string, size) do
    string
    |> String.graphemes()
    |> Enum.chunk_every(size)
    |> Enum.map(&Enum.join/1)
  end
end
