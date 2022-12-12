defmodule PhoneNumber do
  @doc """
  Remove formatting from a phone number if the given number is valid. Return an error otherwise.
  """
  @spec clean(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def clean(raw) do
    with {:ok, phone} <- normalize(raw),
         {:ok, phone} <- validate_length(phone),
         {:ok, phone} <- validate_area_code(phone) do
      validate_exchange_code(phone)
    end
  end

  defp normalize(raw) do
    phone = raw |> String.replace(~r/[-+.()\s]/, "")

    if phone =~ ~r/\D/ do
      {:error, "must contain digits only"}
    else
      {:ok, phone}
    end
  end

  defp validate_length(phone) do
    case phone do
      <<"1", phone::binary-size(10)>> -> {:ok, phone}
      <<phone::binary-size(10)>> -> {:ok, phone}
      <<_::binary-size(11)>> -> {:error, "11 digits must start with 1"}
      _ -> {:error, "incorrect number of digits"}
    end
  end

  defp validate_area_code(phone) do
    case String.at(phone, 0) do
      "0" -> {:error, "area code cannot start with zero"}
      "1" -> {:error, "area code cannot start with one"}
      _ -> {:ok, phone}
    end
  end

  defp validate_exchange_code(phone) do
    case String.at(phone, 3) do
      "0" -> {:error, "exchange code cannot start with zero"}
      "1" -> {:error, "exchange code cannot start with one"}
      _ -> {:ok, phone}
    end
  end
end
