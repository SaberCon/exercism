defmodule Satellite do
  @typedoc """
  A tree, which can be empty, or made from a left branch, a node and a right branch
  """
  @type tree :: {} | {tree, any, tree}

  @doc """
  Build a tree from the elements given in a pre-order and in-order style
  """
  @spec build_tree(preorder :: [any], inorder :: [any]) :: {:ok, tree} | {:error, String.t()}

  def build_tree(preorder, inorder) do
    with :ok <- validate_length(preorder, inorder),
         :ok <- validate_elements(preorder, inorder),
         :ok <- validate_uniq_items(preorder) do
      {:ok, do_build_tree(preorder, inorder)}
    end
  end

  defp validate_length(preorder, inorder) when length(preorder) == length(inorder), do: :ok
  defp validate_length(_, _), do: {:error, "traversals must have the same length"}

  defp validate_elements(preorder, inorder) do
    if Enum.sort(preorder) == Enum.sort(inorder) do
      :ok
    else
      {:error, "traversals must have the same elements"}
    end
  end

  defp validate_uniq_items(items) do
    if items == Enum.uniq(items) do
      :ok
    else
      {:error, "traversals must contain unique items"}
    end
  end

  defp do_build_tree([], []), do: {}

  defp do_build_tree([head | tail], inorder) do
    left_size = Enum.find_index(inorder, &(&1 == head))
    {pre_left, pre_right} = Enum.split(tail, left_size)
    {in_left, [_ | in_right]} = Enum.split(inorder, left_size)

    {do_build_tree(pre_left, in_left), head, do_build_tree(pre_right, in_right)}
  end
end
