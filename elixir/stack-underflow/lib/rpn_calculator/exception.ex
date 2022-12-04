defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception([]) do
      %__MODULE__{}
    end

    @impl true
    def exception(term) do
      %__MODULE__{message: "stack underflow occurred, context: #{term}"}
    end
  end

  def divide(stack) do
    case stack do
      [0, _] -> raise DivisionByZeroError
      [divisor, dividend] -> dividend / divisor
      _ -> raise StackUnderflowError, "when dividing"
    end
  end
end
