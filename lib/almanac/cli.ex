defmodule Almanac.CLI do
  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions
  that end up generating a table of the weather conditions from the specified
  station ID provided as input by the user
  """

  def run(argv) do
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
        body

      {:error, error} ->
        error
    end
  end

  def process(:help) do
    IO.puts("usage: almanac <station_id>")

    System.halt(0)
  end

end
