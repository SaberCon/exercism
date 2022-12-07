defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do
    cond do
      a == b -> :equal
      superlist?(a, b) -> :superlist
      superlist?(b, a) -> :sublist
      true -> :unequal
    end
  end

  defp superlist?(_, []), do: true
  defp superlist?([], _), do: false

  defp superlist?(a, b) do
    List.starts_with?(a, b) or superlist?(tl(a), b)
  end
end
