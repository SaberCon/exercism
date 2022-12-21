defmodule TwoBucket do
  defstruct [:bucket_one, :bucket_two, :moves]
  @type t :: %TwoBucket{bucket_one: integer, bucket_two: integer, moves: integer}

  @doc """
  Find the quickest way to fill a bucket with some amount of water from two buckets of specific sizes.
  """
  @spec measure(
          size_one :: integer,
          size_two :: integer,
          goal :: integer,
          start_bucket :: :one | :two
        ) :: {:ok, TwoBucket.t()} | {:error, :impossible}
  def measure(size_one, size_two, goal, start_bucket) do
    two_bucket =
      case start_bucket do
        :one -> {size_one, 0}
        :two -> {0, size_two}
      end

    seen = MapSet.new([{size_one, 0}, {0, size_two}])
    do_measure([two_bucket], size_one, size_two, goal, 1, seen)
  end

  defp do_measure([], _size_one, _size_two, _goal, _moves, _seen) do
    {:error, :impossible}
  end

  defp do_measure(two_buckets, size_one, size_two, goal, moves, seen) do
    case Enum.find(two_buckets, fn {one, two} -> one == goal or two == goal end) do
      {one, two} ->
        {:ok, %TwoBucket{bucket_one: one, bucket_two: two, moves: moves}}

      nil ->
        next_two_buckets =
          two_buckets
          |> Enum.flat_map(&next(&1, size_one, size_two))
          |> Enum.reject(&MapSet.member?(seen, &1))

        next_seen = next_two_buckets |> Enum.into(seen)

        do_measure(next_two_buckets, size_one, size_two, goal, moves + 1, next_seen)
    end
  end

  defp next({bucket_one, bucket_two}, size_one, size_two) do
    [
      {bucket_one, size_two},
      {size_one, bucket_two},
      {bucket_one, 0},
      {0, bucket_two},
      {max(0, bucket_one - size_two + bucket_two), min(size_two, bucket_two + bucket_one)},
      {min(size_one, bucket_one + bucket_two), max(0, bucket_two - size_one + bucket_one)}
    ]
  end
end
