defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split()
    |> Enum.map_join(" ", &translate_word/1)
  end

  defp translate_word(word) do
    consonants = first_consonants(word)
    rest = String.replace_prefix(word, consonants, "")
    rest <> consonants <> "ay"
  end

  defp first_consonants(word) do
    ~r/^(qu|[xy](?=[aeiou])|[^aeiouxy])*/
    |> Regex.run(word)
    |> hd()
  end
end
