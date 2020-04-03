defmodule Almanac.CLI do
  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions
  that end up generating a table of the weather conditions from the specified
  station ID provided as input by the user
  """

  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a station ID that will be used in the HTTP request to the
  NOAA website.

  Returns the station ID, or `:help` if help was given
  """
  def parse_args(argv) do
    OptionParser.parse_head(argv, aliases: [h: :help], strict: [help: :boolean])
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([station_id]), do: {String.upcase(station_id)}
  def args_to_internal_representation(_), do: :help

  def process({station_id}) do
    case Almanac.WeatherData.fetch(station_id) do
      {:ok, body} ->
        IO.puts("\nLatest Data For #{body[:location]}")
        format_list(body) |> print_conditions()

      {:error, error} ->
        error
    end
  end

  def process(:help) do
    IO.puts("usage: almanac <station_id>")

    System.halt(0)
  end

  def format_list(list) do
    ["Last Updated: #{list[:observation_time]}",
    "Temperature: #{list[:temp_f]}", "Dewpoint: #{list[:dewpoint_string]}",
    "Relative Humidity: #{list[:relative_humidity]}", "Wind: #{list[:wind_string]}",
    "Wind Chill: #{list[:windchill_string]}", "MSL Pressure: #{list[:pressure_string]}",
    "Altimeter: #{list[:pressure_in]}"]
  end

  def print_conditions([]), do: IO.puts("")
  def print_conditions([ head | tail ]) do
    IO.puts(head)
    print_conditions(tail)
  end

end
