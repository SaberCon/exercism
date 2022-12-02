defmodule TakeANumber do
  def start() do
    spawn(&loop/0)
  end

  defp loop(state \\ 0) do
    receive do
      {:report_state, sender} -> report_state(state, sender)
      {:take_a_number, sender} -> take_a_number(state, sender)
      :stop -> :ok
      _ -> loop(state)
    end
  end

  defp report_state(state, sender) do
    send(sender, state)
    loop(state)
  end

  defp take_a_number(state, sender) do
    report_state(state + 1, sender)
  end
end
