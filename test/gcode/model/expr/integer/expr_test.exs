defmodule Gcode.Model.Expr.Integer.ExprTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Expr, Expr.Integer}
  use Gcode.Result
  @moduledoc false

  describe "Expr.evaluate/1" do
    test "when the value is is an integer it evaluates to it" do
      ok(integer) = Integer.init(123)
      assert ok(123) = Expr.evaluate(integer)
    end
  end
end
