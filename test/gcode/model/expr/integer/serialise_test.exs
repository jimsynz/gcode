defmodule Gcode.Model.Expr.Integer.SerialiseTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Expr.Integer, Serialise}
  use Gcode.Result
  @moduledoc false

  describe "Serialise.serialise/1" do
    test "it serialises correctly" do
      ok(float) = Integer.init(123)
      assert ok(["123"]) = Serialise.serialise(float)
    end
  end
end
