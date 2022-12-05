defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) when is_binary(string) do
    string
    |> String.replace(~r/[^a-zA-Z-\s]/, "")
    |> String.split([" ", "-"], trim: true)
    |> Enum.map_join(&String.first/1)
    |> String.upcase()
  end
end
