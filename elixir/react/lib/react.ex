defmodule React do
  defstruct values: %{}, outputs: %{}, callbacks: %{}

  @opaque cells :: pid

  @type cell :: {:input, String.t(), any} | {:output, String.t(), [String.t()], fun()}

  @doc """
  Start a reactive system
  """
  @spec new(cells :: [cell]) :: {:ok, pid}
  def new(cells) do
    Agent.start_link(fn -> init(%__MODULE__{}, cells) end)
  end

  defp init(state, []), do: state

  defp init(state, [{:input, name, value} | rest]) do
    put_in(state.values[name], value)
    |> init(rest)
  end

  defp init(state, [{:output, name, dependencies, fun} | rest]) do
    put_in(state.outputs[name], {dependencies, fun})
    |> then(fn state -> put_in(state.values[name], calculate(state, name)) end)
    |> init(rest)
  end

  defp calculate(state, name) do
    {dependencies, fun} = state.outputs[name]

    dependencies
    |> Enum.map(&state.values[&1])
    |> then(&apply(fun, &1))
  end

  @doc """
  Return the value of an input or output cell
  """
  @spec get_value(cells :: pid, cell_name :: String.t()) :: any()
  def get_value(cells, cell_name) do
    Agent.get(cells, fn state -> state.values[cell_name] end)
  end

  @doc """
  Set the value of an input cell
  """
  @spec set_value(cells :: pid, cell_name :: String.t(), value :: any) :: :ok
  def set_value(cells, cell_name, value) do
    Agent.update(cells, fn state ->
      update_value({state, []}, cell_name, value) |> elem(0)
    end)
  end

  defp update_value({state, updated_values}, cell_name, value) do
    if state.values[cell_name] == value do
      {state, updated_values}
    else
      state.callbacks
      |> Map.get(cell_name, %{})
      |> Enum.each(fn {callback_name, callback} -> callback.(callback_name, value) end)

      new_updated_values = [cell_name | updated_values]
      new_state = put_in(state.values[cell_name], value)

      state.outputs
      |> Stream.filter(fn {_, {dependencies, _}} ->
        cell_name in dependencies and Enum.all?(dependencies, &(&1 in new_updated_values))
      end)
      |> Stream.map(fn {name, _} -> name end)
      |> Enum.reduce({new_state, new_updated_values}, fn name, {state, updated_values} ->
        update_value({state, updated_values}, name)
      end)
    end
  end

  defp update_value({state, updated_values}, cell_name) do
    update_value({state, updated_values}, cell_name, calculate(state, cell_name))
  end

  @doc """
  Add a callback to an output cell
  """
  @spec add_callback(
          cells :: pid,
          cell_name :: String.t(),
          callback_name :: String.t(),
          callback :: fun()
        ) :: :ok
  def add_callback(cells, cell_name, callback_name, callback) do
    Agent.update(cells, fn state ->
      update_in(state.callbacks, &do_add_callback(&1, cell_name, callback_name, callback))
    end)
  end

  defp do_add_callback(callbacks, cell_name, callback_name, callback) do
    callbacks
    |> Map.put_new(cell_name, %{})
    |> put_in([cell_name, callback_name], callback)
  end

  @doc """
  Remove a callback from an output cell
  """
  @spec remove_callback(cells :: pid, cell_name :: String.t(), callback_name :: String.t()) :: :ok
  def remove_callback(cells, cell_name, callback_name) do
    Agent.update(cells, fn state ->
      update_in(state.callbacks, &do_remove_callback(&1, cell_name, callback_name))
    end)
  end

  defp do_remove_callback(callbacks, cell_name, callback_name) do
    callbacks
    |> pop_in([cell_name, callback_name])
    |> elem(1)
  end
end
