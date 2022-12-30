defmodule ZebraPuzzle do
  @colors ~w[red green ivory yellow blue]a
  @inhabitants ~w[englishman spaniard ukrainian norwegian japanese]a
  @beverages ~w[coffee tea milk orange_juice water]a
  @pets ~w[dog snail fox horse zebra]a
  @cigarettes ~w[old_gold kool chesterfield lucky_strike parliament]a

  @doc """
  Determine who drinks the water
  """
  @spec drinks_water() :: atom
  def drinks_water() do
    [_, inhabitants, beverages, _, _] = solution()
    inhabitants |> Enum.at(index(beverages, :water))
  end

  @doc """
  Determine who owns the zebra
  """
  @spec owns_zebra() :: atom
  def owns_zebra() do
    [_, inhabitants, _, pets, _] = solution()
    inhabitants |> Enum.at(index(pets, :zebra))
  end

  defp solution() do
    for colors <- permutations(@colors),
        valid_colors?(colors),
        inhabitants <- permutations(@inhabitants),
        valid_inhabitants?(inhabitants),
        valid_colors_inhabitants?(colors, inhabitants),
        beverages <- permutations(@beverages),
        valid_beverages?(beverages),
        valid_colors_beverages?(colors, beverages),
        valid_inhabitants_beverages?(inhabitants, beverages),
        pets <- permutations(@pets),
        valid_inhabitants_pets?(inhabitants, pets),
        cigarettes <- permutations(@cigarettes),
        valid_colors_cigarettes?(colors, cigarettes),
        valid_inhabitants_cigarettes?(inhabitants, cigarettes),
        valid_beverages_cigarettes?(beverages, cigarettes),
        valid_pets_cigarettes?(pets, cigarettes) do
      [colors, inhabitants, beverages, pets, cigarettes]
    end
    |> Enum.at(0)
  end

  defp permutations([]), do: [[]]

  defp permutations(items) do
    for item <- items,
        rest <- items |> List.delete(item) |> permutations() do
      [item | rest]
    end
  end

  defp valid_colors?(colors) do
    index(colors, :green) == index(colors, :ivory) + 1
  end

  defp valid_inhabitants?(inhabitants) do
    index(inhabitants, :norwegian) == 0
  end

  defp valid_beverages?(beverages) do
    index(beverages, :milk) == 2
  end

  defp valid_colors_inhabitants?(colors, inhabitants) do
    index(colors, :red) == index(inhabitants, :englishman) and
      abs(index(colors, :blue) - index(inhabitants, :norwegian)) == 1
  end

  defp valid_colors_beverages?(colors, beverages) do
    index(colors, :green) == index(beverages, :coffee)
  end

  defp valid_colors_cigarettes?(colors, cigarettes) do
    index(colors, :yellow) == index(cigarettes, :kool)
  end

  defp valid_inhabitants_beverages?(inhabitants, beverages) do
    index(inhabitants, :ukrainian) == index(beverages, :tea)
  end

  defp valid_inhabitants_pets?(inhabitants, pets) do
    index(inhabitants, :spaniard) == index(pets, :dog)
  end

  defp valid_inhabitants_cigarettes?(inhabitants, cigarettes) do
    index(inhabitants, :japanese) == index(cigarettes, :parliament)
  end

  defp valid_beverages_cigarettes?(beverages, cigarettes) do
    index(beverages, :orange_juice) == index(cigarettes, :lucky_strike)
  end

  defp valid_pets_cigarettes?(pets, cigarettes) do
    index(pets, :snail) == index(cigarettes, :old_gold) and
      abs(index(pets, :fox) - index(cigarettes, :chesterfield)) == 1 and
      abs(index(pets, :horse) - index(cigarettes, :kool)) == 1
  end

  defp index(items, item) do
    items |> Enum.find_index(&(&1 == item))
  end
end
