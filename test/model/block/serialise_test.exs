defmodule Gcode.Model.Block.SerialiseTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Block, Serialise, Word}
  use Gcode.Result
  @moduledoc false

  describe "serialise/1" do
    assert ok(block) =
             with(
               ok(block) <- Block.init(),
               ok(word) <- Word.init("G", 0),
               ok(block) <- Block.push(block, word),
               ok(word) <- Word.init("N", 100),
               ok(block) <- Block.push(block, word),
               do: ok(block)
             )

    assert ok([actual]) = Serialise.serialise(block)

    expected = "G0 N100"

    assert actual == expected
  end
end
