defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

      iex> Markdown.parse("This is a paragraph")
      "<p>This is a paragraph</p>"

      iex> Markdown.parse("# Header!\\n* __Bold Item__\\n* _Italic Item_")
      "<h1>Header!</h1><ul><li><strong>Bold Item</strong></li><li><em>Italic Item</em></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(text) do
    text
    |> String.split("\n")
    |> Enum.map_join(&parse_line/1)
    |> parse_style_tags()
    |> wrap_ul()
  end

  defp parse_line("#" <> line), do: parse_header(line, 1)
  defp parse_line("* " <> line), do: "<li>#{line}</li>"
  defp parse_line(line), do: to_paragraph(line)

  defp parse_header(line, 7), do: to_paragraph(String.duplicate("#", 7) <> line)
  defp parse_header(" " <> t, level), do: "<h#{level}>#{t}</h#{level}>"
  defp parse_header("#" <> t, level), do: parse_header(t, level + 1)
  defp parse_header(line, level), do: to_paragraph(String.duplicate("#", level) <> line)

  defp to_paragraph(text), do: "<p>#{text}</p>"

  defp parse_style_tags(text) do
    text
    |> parse_bold_tags()
    |> parse_emphasized_tags()
  end

  defp parse_bold_tags(text), do: String.replace(text, ~r/__([^_]+?)__/, "<strong>\\1</strong>")

  defp parse_emphasized_tags(text), do: String.replace(text, ~r/_([^_]+?)_/, "<em>\\1</em>")

  defp wrap_ul(text), do: String.replace(text, ~r/<li>.*<\/li>/, "<ul>\\0</ul>")
end
