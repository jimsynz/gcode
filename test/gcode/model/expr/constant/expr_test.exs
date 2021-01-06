defmodule Gcode.Model.Expr.Constant.ExprTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Expr, Expr.Constant}
  use Gcode.Result
  @moduledoc false

  describe "Expr.evaluate/1" do
    test "when the constant is `:pi` it returns Pi" do
      ok(const) = Constant.init(:pi)
      assert ok(pi) = Expr.evaluate(const)
      assert_in_delta :math.pi(), pi, 0.1
    end

    test "when the constant is `line` it returns an error" do
      ok(const) = Constant.init(:line)
      assert error(_) = Expr.evaluate(const)
    end

    test "when the constant is `null` it returns `nil`" do
      ok(const) = Constant.init(:null)
      assert ok(nil) = Expr.evaluate(const)
    end

    test "when the constant is `result` it returns an error" do
      ok(const) = Constant.init(:result)
      assert error(_) = Expr.evaluate(const)
    end
  end
end
