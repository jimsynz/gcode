defmodule Gcode.Model.Expr.Unary.ExprTest do
  use ExUnit.Case, async: true

  alias Gcode.Model.{
    Expr,
    Expr.Boolean,
    Expr.Float,
    Expr.Integer,
    Expr.List,
    Expr.String,
    Expr.Unary
  }

  use Gcode.Result
  @moduledoc false

  describe "Expr.evaluate/1" do
    test "when the operator is `!` and the inner value evaluates to a boolean, it returns it's inverse" do
      ok(inner) = Boolean.init(true)
      ok(unary) = Unary.init(:!, inner)
      assert ok(false) = Expr.evaluate(unary)
    end

    test "when the operator is `!` and the inner value evaluates to a non-boolean, it returns an error" do
      ok(inner) = Integer.init(123)
      ok(unary) = Unary.init(:!, inner)
      assert error({:program_error, _}) = Expr.evaluate(unary)
    end

    test "when the operator is `+` the inner value is an integer, it evaluates it" do
      ok(inner) = Integer.init(123)
      ok(inner) = Unary.init(:-, inner)
      ok(unary) = Unary.init(:+, inner)
      assert ok(-123) = Expr.evaluate(unary)
    end

    test "when the operator is `+` the inner value is an float, it evaluates it" do
      ok(inner) = Float.init(1.23)
      ok(unary) = Unary.init(:+, inner)
      assert ok(1.23) = Expr.evaluate(unary)
    end

    test "when the operator is `#` the inner value evaluates to a list, it returns it's length" do
      ok(list) = List.init()
      ok(int) = Integer.init(123)
      ok(inner) = List.push(list, int)
      ok(unary) = Unary.init(:"#", inner)
      assert ok(1) = Expr.evaluate(unary)
    end

    test "when the operator is `#` the inner value evaluates to a string, it returns it's length" do
      ok(inner) = String.init("Marty McFly")
      ok(unary) = Unary.init(:"#", inner)
      assert ok(11) = Expr.evaluate(unary)
    end

    test "when the operator is `#`, otherwise it returns an error" do
      ok(inner) = Integer.init(123)
      ok(unary) = Unary.init(:"#", inner)
      assert error({:program_error, _}) = Expr.evaluate(unary)
    end
  end
end
