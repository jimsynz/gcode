defmodule Gcode.Model.Expr.Unary.SerialiseTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Expr.Integer, Expr.Unary, Serialise}
  use Gcode.Result
  @moduledoc false

  describe "Serialise.serialise/1" do
    for op <- ~w[! + - #]a do
      quote do
        test "when the operator is `#{unquote(op)}` it serialises correctly" do
          ok(inner) = Integer.init(123)
          ok(unary) = Unary.init(unquote(op), inner)
          as_s = to_string(unquote(op))
          assert ok([as_s, "123"]) = Serialise.serialise(unary)
        end
      end
    end
  end
end
