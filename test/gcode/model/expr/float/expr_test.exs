defmodule Gcode.Model.Expr.Float.ExprTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Expr, Expr.Float}
  use Gcode.Result
  @moduledoc false

  describe "Expr.evaluate/1" do
    test "when the value is is a float it evaluates to it" do
      ok(float) = Float.init(1.23)
      assert ok(1.23) = Expr.evaluate(float)
    end
  end
end
