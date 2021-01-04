defmodule Gcode.Model.Program.SerialiseTest do
  use ExUnit.Case, async: true
  use Gcode.Result
  alias Gcode.Model.{Block, Comment, Program, Serialise, Skip, Tape, Word}
  @moduledoc false

  describe "serialise/1" do
    test "it formats correctly" do
      actual =
        with ok(program) <- Program.init(),
             ok(tape) <- Tape.init("The beginning"),
             ok(program) <- Program.push(program, tape),
             ok(comment) <- Comment.init("I am a single line comment"),
             ok(program) <- Program.push(program, comment),
             ok(block) <- Block.init(),
             ok(word) <- Word.init("G", 0),
             ok(block) <- Block.push(block, word),
             ok(word) <- Word.init("N", 100),
             ok(block) <- Block.push(block, word),
             ok(program) <- Program.push(program, block),
             ok(comment) <- Comment.init("I\nam\na\nmultiline\ncomment"),
             ok(program) <- Program.push(program, comment),
             ok(block) <- Block.init(),
             ok(skip) <- Skip.init(),
             ok(block) <- Block.push(block, skip),
             ok(word) <- Word.init("N", 200),
             ok(block) <- Block.push(block, word),
             ok(program) <- Program.push(program, block),
             ok(tape) <- Tape.init("The end"),
             ok(program) <- Program.push(program, tape),
             ok(result) <- Serialise.serialise(program) do
          result
        end

      expected = [
        "% The beginning",
        "(I am a single line comment)",
        "G0 N100",
        "(I)",
        "(am)",
        "(a)",
        "(multiline)",
        "(comment)",
        "/ N200",
        "% The end"
      ]

      assert actual == expected
    end
  end
end
