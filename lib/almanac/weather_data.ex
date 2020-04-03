defmodule Almanac.WeatherData do
  import SweetXml

  @current_obs_url Application.get_env(:almanac, :current_obs_url)

  def fetch(station_id) do
    weather_url(station_id)
    |> HTTPoison.get()
    |> handle_response()
  end

  def weather_url(station_id) do
    "#{@current_obs_url}/#{station_id}.xml"
  end

  def handle_response({_, %{status_code: _, body: body}}) do
    try do
      result = body
      |> parse()
      |> xml_to_map()
      |> List.first()
      |> Map.to_list()

      {:ok, result}
    catch
      :exit, _ -> {:error, "Error fetching data from https://w1.weather.gov/"}
    end
  end

  def xml_to_map(doc) do
    doc
    |> xpath(
      ~x"/current_observation"l,
      location: ~x"./location/text()"s,
      observation_time: ~x"./observation_time/text()"s,
      temp_f: ~x"./temp_f/text()"s,
      dewpoint_string: ~x"./dewpoint_string/text()"s,
      relative_humidity: ~x"./relative_humidity/text()"s,
      wind_string: ~x"./wind_string/text()"s,
      windchill_string: ~x"./windchill_string/text()"s,
      pressure_string: ~x"./pressure_string/text()"s,
      pressure_in: ~x"./pressure_in/text()"s |> transform_by(&(&1 <> " in Hg"))
    )
  end

end
