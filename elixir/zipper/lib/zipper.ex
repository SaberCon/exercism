defmodule Zipper do
  @type t :: %Zipper{node: BinTree.t(), path: [{:left | :right, BinTree.t()}]}

  defstruct [:node, :path]

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree), do: %Zipper{node: bin_tree, path: []}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Zipper{node: node, path: []}), do: node
  def to_tree(%Zipper{path: path}), do: path |> List.last() |> elem(1)

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(%Zipper{node: %BinTree{value: value}}), do: value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%Zipper{node: %BinTree{left: nil}}), do: nil

  def left(%Zipper{node: %BinTree{left: left} = node, path: path}) do
    %Zipper{node: left, path: [{:left, node} | path]}
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%Zipper{node: %BinTree{right: nil}}), do: nil

  def right(%Zipper{node: %BinTree{right: right} = node, path: path}) do
    %Zipper{node: right, path: [{:right, node} | path]}
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{path: []}), do: nil
  def up(%Zipper{path: [{_, parent} | rest]}), do: %Zipper{node: parent, path: rest}

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(%Zipper{node: node} = zipper, value) do
    update(zipper, %{node | value: value})
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(%Zipper{node: node} = zipper, left) do
    update(zipper, %{node | left: left})
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(%Zipper{node: node} = zipper, right) do
    update(zipper, %{node | right: right})
  end

  defp update(%Zipper{path: path}, node) do
    %Zipper{node: node, path: update_path(path, node)}
  end

  defp update_path(path, node) do
    path
    |> Enum.map_reduce(node, fn
      {:left, parent}, node -> %{parent | left: node} |> then(&{{:left, &1}, &1})
      {:right, parent}, node -> %{parent | right: node} |> then(&{{:right, &1}, &1})
    end)
    |> elem(0)
  end
end
