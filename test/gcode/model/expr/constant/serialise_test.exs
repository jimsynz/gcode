defmodule Gcode.Model.Expr.Constant.SerialiseTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Expr.Constant, Serialise}
  use Gcode.Result
  @moduledoc false

  describe "Serialise.serialise/1" do
    test "it serialises correctly" do
      ok(const) = Constant.init(:pi)
      assert ok(["pi"]) = Serialise.serialise(const)
    end
  end
end
