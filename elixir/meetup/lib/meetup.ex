defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @weekdays [
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 7
  ]

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: Date.t()
  def meetup(year, month, weekday, schedule) do
    start =
      case schedule do
        :first -> 1
        :second -> 8
        :third -> 15
        :fourth -> 22
        :last -> Date.days_in_month(Date.new!(year, month, 1)) - 6
        :teenth -> 13
      end

    do_meetup(year, month, start, @weekdays[weekday])
  end

  defp do_meetup(year, month, start, weekday) do
    start..(start + 6)
    |> Enum.map(&Date.new!(year, month, &1))
    |> Enum.find(fn date -> Date.day_of_week(date) == weekday end)
  end
end
