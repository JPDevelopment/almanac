defmodule AlmanacTest do
  use ExUnit.Case
  doctest Almanac

  test "greets the world" do
    assert Almanac.hello() == :world
  end
end
