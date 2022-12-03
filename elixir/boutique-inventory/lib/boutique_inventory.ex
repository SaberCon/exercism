defmodule BoutiqueInventory do
  def sort_by_price(inventory) do
    inventory
    |> Enum.sort_by(fn i -> i.price end)
  end

  def with_missing_price(inventory) do
    inventory
    |> Enum.filter(fn i -> i.price == nil end)
  end

  def update_names(inventory, old_word, new_word) do
    inventory
    |> Enum.map(&update_name(&1, old_word, new_word))
  end

  defp update_name(item, old_word, new_word) do
    item
    |> Map.update!(:name, &String.replace(&1, old_word, new_word))
  end

  def increase_quantity(item, count) do
    item
    |> Map.update!(:quantity_by_size, &increase_quantity_by_size(&1, count))
  end

  defp increase_quantity_by_size(quantity_by_size, count) do
    quantity_by_size
    |> Map.new(fn {size, q} -> {size, q + count} end)
  end

  def total_quantity(item) do
    item.quantity_by_size
    |> Enum.reduce(0, fn {_, q}, acc -> acc + q end)
  end
end
