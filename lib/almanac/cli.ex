defmodule Almanac.CLI do
  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions
  that end up generating a table of the weather conditions from the specified
  station ID provided as input by the user
  """

  def run(argv) do
    parse_args(argv)
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a station ID that will be used in the HTTP request to the
  NOAA website.

  Returns the station ID, or `:help` if help was given
  """

  def parse_args(argv) do
    parse =
      OptionParser.parse(argv,
        switches: [help: :boolean],
        aliases: [h: :help]
      )

    case parse do
      {[help: true], _, _} -> :help
      {_, [station_id], _} -> {String.upcase(station_id)}
      _ -> :help
    end
  end
end
