defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    do_search(numbers, key, 0, tuple_size(numbers) - 1)
  end

  defp do_search(_, _, left, right) when left > right, do: :not_found

  defp do_search(numbers, key, left, right) do
    mid = div(left + right, 2)

    case elem(numbers, mid) do
      ^key -> {:ok, mid}
      num when num > key -> do_search(numbers, key, left, mid - 1)
      num when num < key -> do_search(numbers, key, mid + 1, right)
    end
  end
end
