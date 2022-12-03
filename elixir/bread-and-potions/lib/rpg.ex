defmodule RPG do
  defmodule Character do
    defstruct health: 100, mana: 0
  end

  defmodule LoafOfBread do
    defstruct []
  end

  defmodule ManaPotion do
    defstruct strength: 10
  end

  defmodule Poison do
    defstruct []
  end

  defmodule EmptyBottle do
    defstruct []
  end

  defprotocol Edible do
    def eat(item, character)
  end

  defimpl Edible, for: LoafOfBread do
    def eat(%RPG.LoafOfBread{}, %RPG.Character{} = character) do
      {nil, Map.update!(character, :health, &(&1 + 5))}
    end
  end

  defimpl Edible, for: ManaPotion do
    def eat(%RPG.ManaPotion{strength: strength}, %RPG.Character{} = character) do
      {%RPG.EmptyBottle{}, Map.update!(character, :mana, &(&1 + strength))}
    end
  end

  defimpl Edible, for: Poison do
    def eat(%RPG.Poison{}, %RPG.Character{} = character) do
      {%RPG.EmptyBottle{}, %{character | health: 0}}
    end
  end
end
