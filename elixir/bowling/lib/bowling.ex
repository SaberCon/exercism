defmodule Bowling do
  defstruct ~w[frame round pins buffs score]a

  @pins 10

  @last_frame 10

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: any
  def start do
    %__MODULE__{frame: 1, round: 1, pins: @pins, buffs: [], score: 0}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful error tuple.
  """

  @spec roll(any, integer) :: {:ok, any} | {:error, String.t()}
  def roll(%__MODULE__{frame: :end}, _) do
    {:error, "Cannot roll after game is over"}
  end

  def roll(%__MODULE__{}, point) when point < 0 do
    {:error, "Negative roll is invalid"}
  end

  def roll(%__MODULE__{pins: pins}, point) when point > pins do
    {:error, "Pin count exceeds pins on the lane"}
  end

  def roll(game, point) do
    {:ok, do_roll(game, point)}
  end

  defp do_roll(
         %__MODULE__{frame: @last_frame, round: 1, pins: @pins, buffs: buffs, score: score},
         @pins
       ) do
    %__MODULE__{
      frame: @last_frame,
      round: 3,
      pins: @pins,
      buffs: refresh(buffs, :strike),
      score: score + calculate(@pins, buffs)
    }
  end

  defp do_roll(
         %__MODULE__{frame: @last_frame, round: 2, pins: pins, buffs: buffs, score: score},
         pins
       ) do
    %__MODULE__{
      frame: @last_frame,
      round: 3,
      pins: @pins,
      buffs: refresh(buffs, :spare),
      score: score + calculate(pins, buffs)
    }
  end

  defp do_roll(%__MODULE__{frame: @last_frame, round: 2, buffs: buffs, score: score}, point) do
    end_game(score + calculate(point, buffs))
  end

  defp do_roll(
         %__MODULE__{
           frame: @last_frame,
           round: 3,
           pins: @pins,
           buffs: [:strike | _] = buffs,
           score: score
         },
         point
       ) do
    %__MODULE__{
      frame: @last_frame,
      round: 4,
      pins: if(@pins == point, do: @pins, else: @pins - point),
      buffs: refresh(buffs),
      score: score + calculate(point, buffs) - point
    }
  end

  defp do_roll(%__MODULE__{frame: @last_frame, round: 3, score: score}, point) do
    end_game(score + point)
  end

  defp do_roll(%__MODULE__{frame: @last_frame, round: 4, score: score}, point) do
    end_game(score + point)
  end

  defp do_roll(
         %__MODULE__{frame: frame, round: 1, pins: @pins, buffs: buffs, score: score},
         @pins
       ) do
    %__MODULE__{
      frame: frame + 1,
      round: 1,
      pins: @pins,
      buffs: refresh(buffs, :strike),
      score: score + calculate(@pins, buffs)
    }
  end

  defp do_roll(
         %__MODULE__{frame: frame, round: 1, pins: @pins, buffs: buffs, score: score},
         point
       ) do
    %__MODULE__{
      frame: frame,
      round: 2,
      pins: @pins - point,
      buffs: refresh(buffs),
      score: score + calculate(point, buffs)
    }
  end

  defp do_roll(%__MODULE__{frame: frame, round: 2, pins: pins, buffs: buffs, score: score}, pins) do
    %__MODULE__{
      frame: frame + 1,
      round: 1,
      pins: @pins,
      buffs: refresh(buffs, :spare),
      score: score + calculate(pins, buffs)
    }
  end

  defp do_roll(%__MODULE__{frame: frame, round: 2, buffs: buffs, score: score}, point) do
    %__MODULE__{
      frame: frame + 1,
      round: 1,
      pins: @pins,
      buffs: refresh(buffs),
      score: score + calculate(point, buffs)
    }
  end

  defp calculate(point, buffs) do
    point + point * length(buffs)
  end

  defp refresh(buffs, new_buff \\ nil) do
    buffs
    |> Enum.map(fn
      :spare -> nil
      :strike -> :spare
    end)
    |> List.insert_at(0, new_buff)
    |> Enum.filter(& &1)
  end

  defp end_game(score) do
    %__MODULE__{frame: :end, round: 0, pins: 0, buffs: [], score: score}
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful error tuple.
  """

  @spec score(any) :: {:ok, integer} | {:error, String.t()}
  def score(%__MODULE__{frame: :end, score: score}) do
    {:ok, score}
  end

  def score(%__MODULE__{}) do
    {:error, "Score cannot be taken until the end of the game"}
  end
end
