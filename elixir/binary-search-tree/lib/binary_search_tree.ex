defmodule BinarySearchTree do
  @type bst_node :: %{data: any, left: bst_node | nil, right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data) do
    %{data: data, left: nil, right: nil}
  end

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(%{data: value, left: nil} = tree, data) when value >= data do
    %{tree | left: new(data)}
  end

  def insert(%{data: value, left: left} = tree, data) when value >= data do
    %{tree | left: insert(left, data)}
  end

  def insert(%{right: nil} = tree, data) do
    %{tree | right: new(data)}
  end

  def insert(%{right: right} = tree, data) do
    %{tree | right: insert(right, data)}
  end

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(tree) do
    traverse_reversed([], tree) |> Enum.reverse()
  end

  defp traverse_reversed(acc, nil), do: acc

  defp traverse_reversed(acc, tree) do
    acc
    |> traverse_reversed(tree.left)
    |> List.insert_at(0, tree.data)
    |> traverse_reversed(tree.right)
  end
end
