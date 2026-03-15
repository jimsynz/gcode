defmodule Gcode.Model.Expr.List.ExprTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Expr, Expr.List}
  use Gcode.Result
  @moduledoc false

  describe "Expr.evaluate/1" do
    test "it evaluates an empty list" do
      ok(list) = List.init()
      assert ok([]) = Expr.evaluate(list)
    end
  end
end
