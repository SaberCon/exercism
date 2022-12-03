# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  @not_found {:not_found, "plot is unregistered"}

  def start(opts \\ []) do
    Agent.start(fn -> {[], 1} end, opts)
  end

  def list_registrations(pid) do
    Agent.get(pid, fn {plots, _id} -> plots end)
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn {plots, id} ->
      new_plot = %Plot{plot_id: id, registered_to: register_to}
      {new_plot, {[new_plot | plots], id + 1}}
    end)
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn {plots, id} ->
      new_plots = Enum.reject(plots, &(&1.plot_id == plot_id))
      {new_plots, id}
    end)
  end

  def get_registration(pid, plot_id) do
    Agent.get(pid, fn {plots, _id} ->
      Enum.find(plots, @not_found, &(&1.plot_id == plot_id))
    end)
  end
end
