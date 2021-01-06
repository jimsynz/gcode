defmodule Gcode.Model.Expr.Float.SerialiseTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Expr.Float, Serialise}
  use Gcode.Result
  @moduledoc false

  describe "Serialise.serialise/1" do
    test "it serialises correctly" do
      ok(float) = Float.init(1.23)
      assert ok(["1.23"]) = Serialise.serialise(float)
    end
  end
end
