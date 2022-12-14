defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    dna |> Enum.map(&complement/1)
  end

  defp complement(?G), do: ?C
  defp complement(?C), do: ?G
  defp complement(?T), do: ?A
  defp complement(?A), do: ?U
end
