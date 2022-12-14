defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    Regex.replace(~r/(.)\1*/, string, fn
      char, char -> char
      chars, char -> "#{String.length(chars)}#{char}"
    end)
  end

  def decode(string) do
    Regex.replace(~r/(\d+)(.)/, string, fn _, len, char ->
      String.duplicate(char, String.to_integer(len))
    end)
  end
end
