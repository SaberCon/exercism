defmodule Forth do
  @opaque evaluator :: {
            stacks :: [integer()],
            definitions :: %{required(String.t()) => [String.t() | integer()]}
          }

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    {[], %{}}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    do_eval(ev, normalize_input(s))
  end

  defp normalize_input(input) do
    input
    |> String.downcase()
    |> String.split(~r/[\s\x00\x01]/u, trim: true)
    |> Enum.map(&normalize_word/1)
    |> group_words()
  end

  defp normalize_word(word) do
    case Integer.parse(word) do
      {number, ""} -> number
      _ -> word
    end
  end

  defp group_words(words) do
    chunk_fun = fn
      ":", nil -> {:cont, []}
      ";", list -> {:cont, Enum.reverse(list), nil}
      word, nil -> {:cont, word, nil}
      word, list -> {:cont, [word | list]}
    end

    words
    |> Enum.chunk_while(nil, chunk_fun, fn nil -> {:cont, nil} end)
  end

  defp do_eval(ev, []), do: ev

  defp do_eval({stack, definitions}, [definition | rest])
       when is_map_key(definitions, definition) do
    do_eval({stack, definitions}, definitions[definition] ++ rest)
  end

  defp do_eval({stack, definitions}, [number | rest]) when is_number(number) do
    do_eval({[number | stack], definitions}, rest)
  end

  defp do_eval({[num1, num2 | stack], definitions}, ["+" | rest]) do
    do_eval({[num2 + num1 | stack], definitions}, rest)
  end

  defp do_eval(_, ["+" | _]) do
    raise Forth.StackUnderflow
  end

  defp do_eval({[num1, num2 | stack], definitions}, ["-" | rest]) do
    do_eval({[num2 - num1 | stack], definitions}, rest)
  end

  defp do_eval(_, ["-" | _]) do
    raise Forth.StackUnderflow
  end

  defp do_eval({[num1, num2 | stack], definitions}, ["*" | rest]) do
    do_eval({[num2 * num1 | stack], definitions}, rest)
  end

  defp do_eval(_, ["*" | _]) do
    raise Forth.StackUnderflow
  end

  defp do_eval({[0, _ | _], _}, ["/" | _]) do
    raise Forth.DivisionByZero
  end

  defp do_eval({[num1, num2 | stack], definitions}, ["/" | rest]) do
    do_eval({[Integer.floor_div(num2, num1) | stack], definitions}, rest)
  end

  defp do_eval(_, ["/" | _]) do
    raise Forth.StackUnderflow
  end

  defp do_eval({[num | stack], definitions}, ["dup" | rest]) do
    do_eval({[num, num | stack], definitions}, rest)
  end

  defp do_eval(_, ["dup" | _]) do
    raise Forth.StackUnderflow
  end

  defp do_eval({[_ | stack], definitions}, ["drop" | rest]) do
    do_eval({stack, definitions}, rest)
  end

  defp do_eval(_, ["drop" | _]) do
    raise Forth.StackUnderflow
  end

  defp do_eval({[num1, num2 | stack], definitions}, ["swap" | rest]) do
    do_eval({[num2, num1 | stack], definitions}, rest)
  end

  defp do_eval(_, ["swap" | _]) do
    raise Forth.StackUnderflow
  end

  defp do_eval({[num1, num2 | stack], definitions}, ["over" | rest]) do
    do_eval({[num2, num1, num2 | stack], definitions}, rest)
  end

  defp do_eval(_, ["over" | _]) do
    raise Forth.StackUnderflow
  end

  defp do_eval({stack, definitions}, [definition | rest]) when is_list(definition) do
    do_eval({stack, definitions |> add_definition(definition)}, rest)
  end

  defp do_eval(_, [unknown | _]) do
    raise Forth.UnknownWord, word: unknown
  end

  defp add_definition(_, [key | _]) when is_integer(key) do
    raise Forth.InvalidWord, word: key
  end

  defp add_definition(definitions, [key | definition]) do
    definitions
    |> Map.put(key, normalize_definition(definitions, definition))
  end

  defp normalize_definition(definitions, definition) do
    definition
    |> Enum.flat_map(fn
      key when is_map_key(definitions, key) -> definitions[key]
      word -> [word]
    end)
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack({stack, _}) do
    stack
    |> Enum.reverse()
    |> Enum.join(" ")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
