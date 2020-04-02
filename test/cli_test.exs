defmodule CliTest do
  use ExUnit.Case
  doctest Almanac

  import Almanac.CLI, only: [parse_args: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "station ID returned if station ID given" do
    assert parse_args(["KEWR"]) == {"KEWR"}
  end

  test "properly upcases input for station ID" do
    assert parse_args(["kEwR"]) == {"KEWR"}
  end
end
