defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    options = parse_options(files, flags)
    Enum.map_join(files, &do_grep(&1, pattern, options))
  end

  defp parse_options(files, flags) do
    [
      prepend_file_name: length(files) > 1,
      prepend_line_number: "-n" in flags,
      only_file_name: "-l" in flags,
      caseless: "-i" in flags,
      invert_match: "-v" in flags,
      match_all: "-x" in flags
    ]
  end

  defp do_grep(file, pattern, options) do
    matched_lines =
      file
      |> File.stream!([], :line)
      |> Stream.with_index(1)
      |> Stream.filter(fn {line, _} -> match?(line, pattern, options) end)
      |> Enum.map(fn {line, index} -> format(file, index, line, options) end)

    if length(matched_lines) > 0 and options[:only_file_name] do
      file <> "\n"
    else
      Enum.join(matched_lines)
    end
  end

  defp match?(line, pattern, options) do
    pattern
    |> match_all_if_flagged(options)
    |> Regex.compile!(regex_options(options))
    |> Regex.match?(line)
    |> invert_match_if_flagged(options)
  end

  defp match_all_if_flagged(pattern, options) do
    if options[:match_all], do: pattern |> match_start() |> match_end(), else: pattern
  end

  defp match_start(pattern) do
    if String.starts_with?(pattern, "^"), do: pattern, else: "^" <> pattern
  end

  defp match_end(pattern) do
    if String.ends_with?(pattern, "$"), do: pattern, else: pattern <> "$"
  end

  defp regex_options(options) do
    if options[:caseless], do: [:caseless], else: []
  end

  defp invert_match_if_flagged(match, options) do
    if options[:invert_match], do: not match, else: match
  end

  defp format(file, index, line, options) do
    line
    |> prepend_line_number_if_flagged(index, options)
    |> prepend_file_name_if_flagged(file, options)
  end

  defp prepend_line_number_if_flagged(line, index, options) do
    if options[:prepend_line_number], do: "#{index}:#{line}", else: line
  end

  defp prepend_file_name_if_flagged(line, file, options) do
    if options[:prepend_file_name], do: "#{file}:#{line}", else: line
  end
end
