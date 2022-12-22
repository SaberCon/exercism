defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t()) :: integer
  def answer(question) do
    question
    |> normalize()
    |> do_answer()
  end

  defp normalize(question) do
    if question =~ ~r/^What is -?\d+( (plus|minus|multiplied by|divided by) -?\d+)*\?$/ do
      question
      |> String.replace_prefix("What is ", "")
      |> String.replace_suffix("?", "")
      |> String.split()
      |> Enum.map(fn str ->
        case Integer.parse(str) do
          {num, ""} -> num
          _ -> str
        end
      end)
    else
      raise ArgumentError
    end
  end

  defp do_answer([num]), do: num

  defp do_answer([num1, "plus", num2 | rest]) do
    do_answer([num1 + num2 | rest])
  end

  defp do_answer([num1, "minus", num2 | rest]) do
    do_answer([num1 - num2 | rest])
  end

  defp do_answer([num1, "multiplied", "by", num2 | rest]) do
    do_answer([num1 * num2 | rest])
  end

  defp do_answer([num1, "divided", "by", num2 | rest]) do
    do_answer([num1 / num2 | rest])
  end
end
