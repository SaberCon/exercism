defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str), do: matched?(str, [])

  defp matched?("", []), do: true

  defp matched?("", _), do: false

  defp matched?(<<head, str::binary>>, brackets) when head in '[{(',
    do: matched?(str, [head | brackets])

  defp matched?(<<?], str::binary>>, [?[ | brackets]), do: matched?(str, brackets)

  defp matched?(<<?}, str::binary>>, [?{ | brackets]), do: matched?(str, brackets)

  defp matched?(<<?), str::binary>>, [?( | brackets]), do: matched?(str, brackets)

  defp matched?(<<head, _::binary>>, _) when head in ']})', do: false

  defp matched?(<<_, str::binary>>, brackets), do: matched?(str, brackets)
end
