defmodule Dot do
  defmacro graph(do: ast) do
    {_, graph} = Macro.prewalk(ast, Graph.new(), &build_graph/2)
    Macro.escape(graph)
  end

  defp build_graph({:graph, _, [attrs]}, graph) do
    {{}, Graph.put_attrs(graph, attrs)}
  end

  defp build_graph({:--, _, [{node1, _, _}, {node2, _, nil}]}, graph) do
    {{}, Graph.add_edge(graph, node1, node2)}
  end

  defp build_graph({:--, _, [{node1, _, _}, {node2, _, [attrs]}]}, graph) when is_list(attrs) do
    {{}, Graph.add_edge(graph, node1, node2, attrs)}
  end

  defp build_graph({node, _, nil}, graph) do
    {{}, Graph.add_node(graph, node)}
  end

  defp build_graph({node, _, [attrs]}, graph) when is_list(attrs) do
    {{}, Graph.add_node(graph, node, attrs)}
  end

  defp build_graph(ast, graph) when is_tuple(ast) do
    {ast, graph}
  end

  defp build_graph(_, _), do: raise(ArgumentError)
end
