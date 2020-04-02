defmodule Almanac.WeatherData do
  def fetch(station_id) do
    weather_url(station_id)
    |> HTTPoison.get()
    |> handle_response()
  end

  def weather_url(station_id) do
    "https://w1.weather.gov/xml/current_obs/#{station_id}.xml"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}), do: {:ok, body}
  def handle_response({_, %{status_code: _, body: body}}), do: {:error, body}
end
