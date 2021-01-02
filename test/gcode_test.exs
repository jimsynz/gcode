defmodule GcodeTest do
  use ExUnit.Case
  doctest Gcode

  test "greets the world" do
    assert Gcode.hello() == :world
  end
end
