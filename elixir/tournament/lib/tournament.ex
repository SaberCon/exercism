defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    input
    |> Enum.flat_map(&parse_match/1)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.map(fn {team, scores} -> {team, parse_scores(scores)} end)
    |> sort_outcome()
    |> format_outcome()
  end

  defp parse_match(match) do
    case match |> String.split(";") do
      [team1, team2, "draw"] -> [{team1, 1}, {team2, 1}]
      [team1, team2, "win"] -> [{team1, 3}, {team2, 0}]
      [team1, team2, "loss"] -> [{team1, 0}, {team2, 3}]
      _ -> []
    end
  end

  defp parse_scores(scores) do
    mp = Enum.count(scores)
    w = Enum.count(scores, &(&1 == 3))
    d = Enum.count(scores, &(&1 == 1))
    l = Enum.count(scores, &(&1 == 0))
    p = Enum.sum(scores)
    {mp, w, d, l, p}
  end

  defp sort_outcome(outcome) do
    outcome
    |> Enum.sort_by(fn {team, {_, _, _, _, p}} -> {-p, team} end)
  end

  defp format_outcome(outcome) do
    [title() | outcome]
    |> Enum.map_join("\n", &format_row/1)
  end

  defp title() do
    {"Team", {"MP", "W", "D", "L", "P"}}
  end

  defp format_row({team, stats}) do
    [pad_header(team) | Tuple.to_list(stats) |> Enum.map(&pad_column/1)]
    |> Enum.join(" |")
  end

  defp pad_header(data) do
    data |> to_string() |> String.pad_trailing(30)
  end

  defp pad_column(data) do
    data |> to_string() |> String.pad_leading(3)
  end
end
