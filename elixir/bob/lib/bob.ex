defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    input = String.trim(input)

    cond do
      question?(input) and yell?(input) -> "Calm down, I know what I'm doing!"
      question?(input) -> "Sure."
      yell?(input) -> "Whoa, chill out!"
      silence?(input) -> "Fine. Be that way!"
      true -> "Whatever."
    end
  end

  defp silence?(input), do: input == ""
  defp question?(input), do: String.last(input) == "?"
  defp yell?(input), do: String.upcase(input) == input and String.downcase(input) != input
end
