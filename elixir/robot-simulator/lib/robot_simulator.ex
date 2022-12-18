defmodule RobotSimulator do
  @directions ~w[north east south west]a

  @type robot() :: {direction(), {integer(), integer()}}
  @type direction() :: :north | :east | :south | :west
  @type position() :: {integer(), integer()}

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction, position) :: robot() | {:error, String.t()}
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, _) when direction not in @directions do
    {:error, "invalid direction"}
  end

  def create(direction, {x, y}) when is_integer(x) and is_integer(y) do
    {direction, {x, y}}
  end

  def create(_, _) do
    {:error, "invalid position"}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot, instructions :: String.t()) :: robot() | {:error, String.t()}
  def simulate(robot, ""), do: robot
  def simulate(robot, "L" <> rest), do: robot |> turn(-1) |> simulate(rest)
  def simulate(robot, "R" <> rest), do: robot |> turn(1) |> simulate(rest)
  def simulate(robot, "A" <> rest), do: robot |> advance() |> simulate(rest)
  def simulate(_, _), do: {:error, "invalid instruction"}

  defp turn({direction, position}, delta) do
    @directions
    |> Enum.find_index(&(&1 == direction))
    |> Kernel.+(delta)
    |> Integer.mod(length(@directions))
    |> then(&Enum.at(@directions, &1))
    |> then(&{&1, position})
  end

  defp advance({:north, {x, y}}), do: {:north, {x, y + 1}}
  defp advance({:east, {x, y}}), do: {:east, {x + 1, y}}
  defp advance({:south, {x, y}}), do: {:south, {x, y - 1}}
  defp advance({:west, {x, y}}), do: {:west, {x - 1, y}}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot) :: direction()
  def direction({direction, _}), do: direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot) :: position()
  def position({_, position}), do: position
end
