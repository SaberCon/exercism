defmodule CircularBuffer do
  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity) do
    Agent.start(fn -> {capacity, []} end)
  end

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer) do
    buffer
    |> Agent.get_and_update(fn
      {capacity, []} -> {{:error, :empty}, {capacity, []}}
      {capacity, [head | tail]} -> {{:ok, head}, {capacity, tail}}
    end)
  end

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item) do
    buffer
    |> Agent.get_and_update(fn
      {capacity, entries} when capacity == length(entries) ->
        {{:error, :full}, {capacity, entries}}

      {capacity, entries} ->
        {:ok, {capacity, entries ++ [item]}}
    end)
  end

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item) do
    buffer
    |> Agent.update(fn
      {capacity, entries} when capacity == length(entries) ->
        {capacity, tl(entries) ++ [item]}

      {capacity, entries} ->
        {capacity, entries ++ [item]}
    end)
  end

  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer) do
    buffer |> Agent.update(fn {capacity, _} -> {capacity, []} end)
  end
end
