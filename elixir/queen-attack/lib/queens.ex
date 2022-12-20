defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  def new(opts \\ []) do
    {black, white} = parse_opts(opts)

    %Queens{black: black, white: white}
  end

  defp parse_opts(opts) do
    {black, opts} = opts |> Keyword.pop(:black)
    {white, opts} = opts |> Keyword.pop(:white)

    unless opts == [] and black != white and valid_position?(black) and valid_position?(white) do
      raise ArgumentError
    end

    {black, white}
  end

  defp valid_position?(nil), do: true
  defp valid_position?({x, y}) when x in 0..7 and y in 0..7, do: true
  defp valid_position?(_), do: false

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(%Queens{black: black, white: white}) do
    0..7
    |> Enum.map_join("\n", fn x ->
      0..7
      |> Enum.map_join(" ", fn y -> to_square({x, y}, black, white) end)
    end)
  end

  defp to_square(black, black, _), do: "B"
  defp to_square(white, _, white), do: "W"
  defp to_square(_, _, _), do: "_"

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{black: {x, _}, white: {x, _}}), do: true
  def can_attack?(%Queens{black: {_, y}, white: {_, y}}), do: true

  def can_attack?(%Queens{black: {bx, by}, white: {wx, wy}})
      when abs(bx - wx) == abs(by - wy),
      do: true

  def can_attack?(%Queens{}), do: false
end
