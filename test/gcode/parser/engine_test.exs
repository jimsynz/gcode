defmodule Gcode.Parser.EngineTest do
  use ExUnit.Case, async: true
  use Gcode.Result
  use ParserEngineHelper
  import FixtureHelper
  @moduledoc false

  it_parses_into("%", tape: '')
  it_parses_into("% hello", tape: 'hello')
  it_parses_into("()", comment: '')
  it_parses_into("(hello)", comment: 'hello')
  it_parses_into("( hello )", comment: 'hello')
  it_parses_into("; hello", comment: 'hello')
  it_parses_into("G0", block: [word: [command: 'G', address: [integer: '0']]])
  it_parses_into("G 0", block: [word: [command: 'G', address: [integer: '0']]])
  it_parses_into("G54.1", block: [word: [command: 'G', address: [float: '54.1']]])
  it_parses_into("G 54.1", block: [word: [command: 'G', address: [float: '54.1']]])
  it_parses_into("G-1", block: [word: [command: 'G', address: [{:-, [integer: '1']}]]])
  it_parses_into("G+1", block: [word: [command: 'G', address: [{:+, [integer: '1']}]]])
  it_parses_into("G!1", block: [word: [command: 'G', address: [{:!, [integer: '1']}]]])

  it_parses_into("G1 X112.518 Y131.525 E59.51636 (hello)",
    block: [
      word: [command: 'G', address: [integer: '1']],
      word: [command: 'X', address: [float: '112.518']],
      word: [command: 'Y', address: [float: '131.525']],
      word: [command: 'E', address: [float: '59.51636']],
      comment: 'hello'
    ]
  )

  it_parses_into("M82 ;absolute extrusion mode",
    block: [word: [command: 'M', address: [integer: '82']], comment: 'absolute extrusion mode']
  )

  it_parses_into("M117 Hello world",
    block: [word: [command: 'M', address: [integer: '117']], string: 'Hello world']
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
