defmodule Gcode.Model.Expr.UnaryTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.Expr.{Integer, Unary}
  use Gcode.Option
  use Gcode.Result
  @moduledoc false

  describe "init/2" do
    test "when the operator is valid and the inner value is an expression, it is ok" do
      ok(inner) = Integer.init(123)
      assert ok(%Unary{op: some(:-), expr: some(^inner)}) = Unary.init(:-, inner)
    end

    test "when the operator is valid and the inner value is not an expresion, it is an error" do
      assert error({:expression_error, _}) = Unary.init(:-, 1.21)
    end

    test "when the inner value is an expression but the operator is invalid, it an error" do
      ok(inner) = Integer.init(123)
      assert error({:expression_error, _}) = Unary.init(:%, inner)
    end

    test "when both the operator and inner value are invalid, it is an error" do
      assert error({:expression_error, _}) = Unary.init(:%, 1.21)
    end
  end
end
