defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct [
    :nickname,
    battery_percentage: 100,
    distance_driven_in_meters: 0
  ]

  def new(nickname \\ "none"), do: %__MODULE__{nickname: nickname}

  def display_distance(%__MODULE__{distance_driven_in_meters: distance}) do
    "#{distance} meters"
  end

  def display_battery(%__MODULE__{battery_percentage: 0}), do: "Battery empty"

  def display_battery(%__MODULE__{battery_percentage: battery}) do
    "Battery at #{battery}%"
  end

  def drive(%__MODULE__{battery_percentage: 0} = remote_car), do: remote_car

  def drive(
        %__MODULE__{
          distance_driven_in_meters: distance,
          battery_percentage: battery
        } = remote_car
      ) do
    %{remote_car | distance_driven_in_meters: distance + 20, battery_percentage: battery - 1}
  end
end
