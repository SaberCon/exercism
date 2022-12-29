defmodule Pov do
  @typedoc """
  A tree, which is made of a node with several branches
  """
  @type tree :: {any, [tree]}

  @doc """
  Reparent a tree on a selected node.
  """
  @spec from_pov(tree :: tree, node :: any) :: {:ok, tree} | {:error, atom}
  def from_pov(tree, node) do
    case find_path(tree, node) do
      {:ok, path} -> {:ok, do_from_pov(tree, tl(path), [])}
      {:error, _} -> {:error, :nonexistent_target}
    end
  end

  defp do_from_pov({node, branches}, [], acc) do
    {node, branches ++ acc}
  end

  defp do_from_pov({node, [{target, _} = head | tail]}, [target | rest], acc) do
    do_from_pov(head, rest, [{node, tail ++ acc}])
  end

  defp do_from_pov({node, [head | tail]}, path, acc) do
    do_from_pov({node, tail}, path, [head | acc])
  end

  @doc """
  Finds a path between two nodes
  """
  @spec path_between(tree :: tree, from :: any, to :: any) :: {:ok, [any]} | {:error, atom}
  def path_between(tree, from, to) do
    with {:ok, from_tree} <- from_pov(tree, from),
         {:ok, path} <- find_path(from_tree, to) do
      {:ok, path}
    else
      {:error, :nonexistent_target} -> {:error, :nonexistent_source}
      {:error, :nonexistent_path} -> {:error, :nonexistent_destination}
    end
  end

  defp find_path({target, _branches}, target), do: {:ok, [target]}
  defp find_path({_node, []}, _target), do: {:error, :nonexistent_path}

  defp find_path({node, [head | tail]}, target) do
    case find_path(head, target) do
      {:ok, path} -> {:ok, [node | path]}
      {:error, _} -> find_path({node, tail}, target)
    end
  end
end
