defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> Task.async_stream(&do_frequency/1, max_concurrent: workers)
    |> Stream.map(fn {:ok, result} -> result end)
    |> merge()
  end

  defp do_frequency(text) do
    text
    |> String.downcase()
    |> String.graphemes()
    |> Stream.filter(&(&1 =~ ~r/[[:alpha:]]/))
    |> Enum.frequencies()
  end

  defp merge(frequencies_list) do
    Enum.reduce(frequencies_list, %{}, &merge/2)
  end

  defp merge(frequencies1, frequencies2) do
    Map.merge(frequencies1, frequencies2, fn _k, v1, v2 -> v1 + v2 end)
  end
end
