defmodule GcodeTest do
  use ExUnit.Case, async: true
  use Gcode.Result
  alias Gcode.Model.{Comment, Program, Tape}
  doctest Gcode
  @moduledoc false

  describe "serialise/1" do
    test "it serialises a program correctly" do
      program = Program.init()
      ok(program) = Program.push(program, Tape.init())
      ok(program) = Program.push(program, Comment.init("I am a very simple program"))
      ok(program) = Program.push(program, Tape.init())
      ok(actual) = Gcode.serialise(program)

      expected = "%\r\n(I am a very simple program)\r\n%\r\n"

      assert actual == expected
    end
  end
end
