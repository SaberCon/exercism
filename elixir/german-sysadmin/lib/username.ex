defmodule Username do
  defguard is_lowercase(code) when code >= ?a and code <= ?z
  defguard is_underscore(code) when code == ?_

  def sanitize(username) do
    username
    |> Enum.flat_map(&substitute_german_chars/1)
    |> Enum.filter(&(is_lowercase(&1) or is_underscore(&1)))
  end

  defp substitute_german_chars(code) do
    case code do
      ?ä -> 'ae'
      ?ö -> 'oe'
      ?ü -> 'ue'
      ?ß -> 'ss'
      _ -> [code]
    end
  end
end
