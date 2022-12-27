defmodule SgfParsing do
  defmodule Sgf do
    defstruct properties: %{}, children: []
  end

  @type sgf :: %Sgf{properties: map, children: [sgf]}

  @doc """
  Parse a string into a Smart Game Format tree
  """
  @spec parse(encoded :: String.t()) :: {:ok, sgf} | {:error, String.t()}
  def parse(encoded) do
    with :ok <- validate(encoded) do
      encoded
      |> do_parse()
      |> hd()
      |> then(&{:ok, &1})
    end
  end

  defp validate(encoded) do
    cond do
      !String.match?(encoded, ~r/^\(.*\)$/) ->
        {:error, "tree missing"}

      !String.match?(encoded, ~r/^\(;.*\)$/) ->
        {:error, "tree with no nodes"}

      String.match?(encoded, ~r/[a-z][A-Z]*\[/) ->
        {:error, "property must be in uppercase"}

      String.match?(encoded, ~r/;[A-Z]+[^[]/) ->
        {:error, "properties without delimiter"}

      true ->
        :ok
    end
  end

  defp do_parse(""), do: []

  defp do_parse(encoded) do
    if encoded =~ ~r/^\(.+\)$/ do
      do_split_parse(encoded, 0, "")
    else
      case encoded |> String.slice(1..-1//1) |> String.split(~r/(?=\(?;)/, parts: 2) do
        [part1] -> [%Sgf{properties: parse_properties(part1)}]
        [part1, part2] -> [%Sgf{properties: parse_properties(part1), children: do_parse(part2)}]
      end
    end
  end

  defp do_split_parse(")" <> rest, 1, acc) do
    do_parse(acc |> String.slice(1..-1//1)) ++ do_split_parse(rest, 0, "")
  end

  defp do_split_parse(")" <> rest, parentheses, acc) do
    do_split_parse(rest, parentheses - 1, acc <> ")")
  end

  defp do_split_parse("(" <> rest, parentheses, acc) do
    do_split_parse(rest, parentheses + 1, acc <> "(")
  end

  defp do_split_parse(<<char, rest::binary>>, parentheses, acc) do
    do_split_parse(rest, parentheses, acc <> <<char>>)
  end

  defp do_split_parse("", 0, ""), do: []

  defp parse_properties(encoded_properties) do
    encoded_properties
    |> String.split(~r/[A-Z]+(\[.*?[^\\]\])+/, include_captures: true, trim: true)
    |> Enum.map(&parse_property/1)
    |> Map.new()
  end

  defp parse_property(encoded_property) do
    [key | values] =
      encoded_property
      |> String.split(~r/\[.*?[^\\]\]/, include_captures: true, trim: true)

    {key, values |> Enum.map(&normalize_property_value/1)}
  end

  defp normalize_property_value(value) do
    value
    |> String.slice(1..-2//1)
    |> String.replace("\\n", "\n")
    |> String.replace("\\t", "\t")
    |> String.replace("\\[", "[")
    |> String.replace("\\]", "]")
  end
end
