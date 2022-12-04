defmodule RPNCalculator do
  def calculate!(stack, operation) do
    operation.(stack)
  end

  def calculate(stack, operation) do
    {:ok, calculate!(stack, operation)}
  rescue
    _ -> :error
  end

  def calculate_verbose(stack, operation) do
    {:ok, calculate!(stack, operation)}
  rescue
    e -> {:error, e.message}
  end
end
