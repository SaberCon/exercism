defmodule CustomSet do
  @opaque t :: %__MODULE__{map: map}

  defstruct map: %{}

  defp from_map(map), do: %__MODULE__{map: map}

  @spec new(Enum.t()) :: t
  def new(enumerable) do
    enumerable
    |> Map.from_keys(true)
    |> from_map()
  end

  @spec empty?(t) :: boolean
  def empty?(%__MODULE__{map: map}), do: map == %{}

  @spec contains?(t, any) :: boolean
  def contains?(%__MODULE__{map: map}, element), do: Map.has_key?(map, element)

  @spec subset?(t, t) :: boolean
  def subset?(custom_set_1, custom_set_2) do
    difference(custom_set_1, custom_set_2)
    |> empty?()
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(custom_set_1, custom_set_2) do
    intersection(custom_set_1, custom_set_2)
    |> empty?()
  end

  @spec equal?(t, t) :: boolean
  def equal?(%__MODULE__{map: map}, %__MODULE__{map: map}), do: true
  def equal?(%__MODULE__{}, %__MODULE__{}), do: false

  @spec add(t, any) :: t
  def add(%__MODULE__{map: map}, element) do
    Map.put_new(map, element, true)
    |> from_map()
  end

  @spec intersection(t, t) :: t
  def intersection(%__MODULE__{map: map1}, %__MODULE__{map: map2}) do
    map1
    |> Map.take(Map.keys(map2))
    |> from_map()
  end

  @spec difference(t, t) :: t
  def difference(%__MODULE__{map: map1}, %__MODULE__{map: map2}) do
    map1
    |> Map.drop(Map.keys(map2))
    |> from_map()
  end

  @spec union(t, t) :: t
  def union(%__MODULE__{map: map1}, %__MODULE__{map: map2}) do
    map1
    |> Map.merge(map2)
    |> from_map()
  end
end
