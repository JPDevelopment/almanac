defmodule Almanac.WeatherData do
  @current_obs_url Application.get_env(:almanac, :current_obs_url)
  import SweetXml

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
      doc = parse(body)
      format_xml(doc)
    catch
      :exit, _ -> {:error, "Invalid XML"}
    end
  end

  def format_xml(doc) do
    doc |> xpath(
      ~x"/current_observation"l,
      location: ~x"./location/text()",
      observation_time: ~x"./observation_time/text()",
      temp_f: ~x"./temp_f/text()",
      dewpoint_string: ~x"./dewpoint_string/text()",
      relative_humidity: ~x"./relative_humidity/text()",
      wind_string: ~x"./wind_string/text()",
      windchill_string: ~x"./windchill_string/text()",
      pressure_string: ~x"./pressure_string/text()",
      pressure_in: ~x"./pressure_in/text()"
    )
  end

end
