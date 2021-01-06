defmodule Gcode.Model.Block.SerialiseTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Block, Expr, Serialise, Word}
  use Gcode.Result
  @moduledoc false

  describe "serialise/1" do
    assert ok(block) =
             with(
               ok(block) <- Block.init(),
               ok(address) <- Expr.Integer.init(0),
               ok(word) <- Word.init("G", address),
               ok(block) <- Block.push(block, word),
               ok(address) <- Expr.Integer.init(100),
               ok(word) <- Word.init("N", address),
               ok(block) <- Block.push(block, word),
               do: ok(block)
             )

    assert ok([actual]) = Serialise.serialise(block)

    expected = "G0 N100"

    assert actual == expected
  end
end
