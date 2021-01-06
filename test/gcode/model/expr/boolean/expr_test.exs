defmodule Gcode.Model.Expr.Boolean.ExprTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Expr, Expr.Boolean}
  use Gcode.Result
  @moduledoc false

  describe "Expr.evaluate/1" do
    test "when the value is `true` it evaluates to `true`" do
      ok(bool) = Boolean.init(true)
      assert ok(true) = Expr.evaluate(bool)
    end

    test "when the value is `false` it evaluates to `false`" do
      ok(bool) = Boolean.init(false)
      assert ok(false) = Expr.evaluate(bool)
    end
  end
end
