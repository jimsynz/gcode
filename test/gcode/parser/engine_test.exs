defmodule Gcode.Parser.EngineTest do
  use ExUnit.Case, async: true
  use Gcode.Result
  use ParserEngineHelper
  import FixtureHelper
  @moduledoc false

  it_parses_into("%", tape: ~c"")
  it_parses_into("% hello", tape: ~c"hello")
  it_parses_into("()", comment: ~c"")
  it_parses_into("(hello)", comment: ~c"hello")
  it_parses_into("( hello )", comment: ~c"hello")
  it_parses_into("; hello", comment: ~c"hello")
  it_parses_into("G0", block: [word: [command: ~c"G", address: [integer: ~c"0"]]])
  it_parses_into("G 0", block: [word: [command: ~c"G", address: [integer: ~c"0"]]])
  it_parses_into("G54.1", block: [word: [command: ~c"G", address: [float: ~c"54.1"]]])
  it_parses_into("G 54.1", block: [word: [command: ~c"G", address: [float: ~c"54.1"]]])
  it_parses_into("G-1", block: [word: [command: ~c"G", address: [{:-, [integer: ~c"1"]}]]])
  it_parses_into("G+1", block: [word: [command: ~c"G", address: [{:+, [integer: ~c"1"]}]]])
  it_parses_into("G!1", block: [word: [command: ~c"G", address: [{:!, [integer: ~c"1"]}]]])

  it_parses_into("G1 X112.518 Y131.525 E59.51636 (hello)",
    block: [
      word: [command: ~c"G", address: [integer: ~c"1"]],
      word: [command: ~c"X", address: [float: ~c"112.518"]],
      word: [command: ~c"Y", address: [float: ~c"131.525"]],
      word: [command: ~c"E", address: [float: ~c"59.51636"]],
      comment: ~c"hello"
    ]
  )

  it_parses_into("M82 ;absolute extrusion mode",
    block: [
      word: [command: ~c"M", address: [integer: ~c"82"]],
      comment: ~c"absolute extrusion mode"
    ]
  )

  it_parses_into("M117 Hello world",
    block: [word: [command: ~c"M", address: [integer: ~c"117"]], string: ~c"Hello world"]
  )

  it_parses_into(read_fixture("fusion_360_milling_grbl.nc"), fn tokens ->
    lines =
      tokens
      |> Enum.reject(&(elem(&1, 0) == :newline))
      |> Enum.count()

    assert lines == 500
  end)

  it_parses_into(read_fixture("cura_marlin.gcode"), fn tokens ->
    lines =
      tokens
      |> Enum.reject(&(elem(&1, 0) == :newline))
      |> Enum.count()

    assert lines == 6723
  end)
end
