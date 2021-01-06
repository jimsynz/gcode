defmodule Gcode.ParserTest do
  use ExUnit.Case, async: true
  alias Gcode.Parser
  alias Gcode.Model.{Block, Comment, Expr, Program, Word}
  use Gcode.Option
  use Gcode.Result
  import FixtureHelper
  @moduledoc false

  describe "parse_string/1" do
    test "( hello )" do
      assert ok(program) = Parser.parse_string("( hello )")
      assert %Program{elements: [%Comment{comment: "hello"}]} = program
    end

    test "G29" do
      assert ok(program) = Parser.parse_string("G29")

      assert %Program{
               elements: [%Block{words: [%Word{word: "G", address: %Expr.Integer{i: 29}}]}]
             } = program
    end

    test "G54.1" do
      assert ok(program) = Parser.parse_string("G54.1")

      assert %Program{
               elements: [%Block{words: [%Word{word: "G", address: %Expr.Float{f: 54.1}}]}]
             } = program
    end

    test "X-12" do
      assert ok(program) = Parser.parse_string("X-12")

      assert %Program{
               elements: [
                 %Block{
                   words: [
                     %Word{
                       word: "X",
                       address: %Expr.Unary{
                         op: some(:-),
                         expr: some(%Expr.Integer{i: 12})
                       }
                     }
                   ]
                 }
               ]
             } = program
    end

    test "M117 Marty McFly" do
      assert ok(program) = Parser.parse_string("M117 Marty McFly")

      assert %Program{
               elements: [
                 %Block{
                   words: [
                     %Expr.String{value: "Marty McFly"},
                     %Word{word: "M", address: %Expr.Integer{i: 117}}
                   ]
                 }
               ]
             } = program
    end

    test "it can parse `fusion_360_milling_grbl.nc`" do
      input = read_fixture("fusion_360_milling_grbl.nc")
      assert ok(%Program{}) = Parser.parse_string(input)
    end

    test "it can parse `cura_marlin.gcode`" do
      input = read_fixture("cura_marlin.gcode")
      assert ok(%Program{}) = Parser.parse_string(input)
    end
  end

  describe "parse_file/1" do
    test "it can parse `fusion_360_milling_grbl.nc`" do
      assert ok(%Program{elements: elements}) =
               Parser.parse_file(fixture_path("fusion_360_milling_grbl.nc"))

      assert 500 = length(elements)
    end

    test "it can parse `cura_marlin.gcode`" do
      assert ok(%Program{elements: elements}) =
               Parser.parse_file(fixture_path("cura_marlin.gcode"))

      assert 6723 = length(elements)
    end
  end

  describe "stream_string!/1" do
    test "it can stream `fusion_360_milling_grbl.nc`" do
      elements =
        read_fixture("fusion_360_milling_grbl.nc")
        |> Parser.stream_string!()
        |> Enum.to_list()

      assert 500 = length(elements)
    end

    test "it can stream `cura_marlin.gcode`" do
      elements =
        read_fixture("cura_marlin.gcode")
        |> Parser.stream_string!()
        |> Enum.to_list()

      assert 6723 = length(elements)
    end
  end

  describe "stream_file!/1" do
    test "it can stream `fusion_360_milling_grbl.nc`" do
      elements =
        fixture_path("fusion_360_milling_grbl.nc")
        |> Parser.stream_file!()
        |> Enum.to_list()

      assert 500 = length(elements)
    end

    test "it can stream `cura_marlin.gcode`" do
      elements =
        fixture_path("cura_marlin.gcode")
        |> Parser.stream_file!()
        |> Enum.to_list()

      assert 6723 = length(elements)
    end
  end
end
