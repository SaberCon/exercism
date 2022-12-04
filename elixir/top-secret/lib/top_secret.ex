defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string)
  end

  def decode_secret_message_part({op, _, [fun_part | _]} = ast, acc)
      when op in [:def, :defp] do
    {ast, decode_function_part(fun_part, acc)}
  end

  def decode_secret_message_part(ast, acc) do
    {ast, acc}
  end

  defp decode_function_part({:when, _, [fun | _]}, acc) do
    decode_function_part(fun, acc)
  end

  defp decode_function_part({name, _, args}, acc) do
    [decode_function(name, args) | acc]
  end

  defp decode_function(name, args) do
    name
    |> to_string()
    |> String.slice(0, length(args || []))
  end

  def decode_secret_message(string) do
    to_ast(string)
    |> Macro.prewalk([], &decode_secret_message_part/2)
    |> elem(1)
    |> Enum.reverse()
    |> Enum.join()
  end
end
