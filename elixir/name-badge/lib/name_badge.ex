defmodule NameBadge do
  def print(id, name, nil), do: print(id, name, "OWNER")

  def print(id, name, department) do
    [if(id, do: "[#{id}]"), name, String.upcase(department)]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" - ")
  end
end
