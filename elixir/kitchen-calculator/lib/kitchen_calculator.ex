defmodule KitchenCalculator do
  @ratios %{
    milliliter: 1,
    cup: 240,
    fluid_ounce: 30,
    teaspoon: 5,
    tablespoon: 15
  }

  def get_volume({_, volume}), do: volume

  def to_milliliter({unit, volume}) do
    {:milliliter, volume * @ratios[unit]}
  end

  def from_milliliter({:milliliter, volume}, unit) do
    {unit, volume / @ratios[unit]}
  end

  def convert(volume_pair, unit) do
    to_milliliter(volume_pair) |> from_milliliter(unit)
  end
end
