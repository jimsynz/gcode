defmodule Gcode.Model.Expr.ListTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.Expr.{Integer, List}
  use Gcode.Result
  @moduledoc false

  describe "init/1" do
    test "it is ok" do
      assert ok(%List{}) = List.init()
    end
  end

  describe "push/2" do
    test "when the element is an expression, it is ok" do
      ok(list) = List.init()
      ok(expr) = Integer.init(123)
      assert ok(%List{elements: [^expr]}) = List.push(list, expr)
    end

    test "otherwise it's an error" do
      ok(list) = List.init()
      assert error({:expression_error, _}) = List.push(list, :marty)
    end
  end
end
