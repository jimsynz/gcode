defmodule Gcode.Model.Expr.Binary.SerialiseTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Expr.Binary, Expr.Integer, Serialise}
  use Gcode.Result
  @moduledoc false

  describe "Serialise.serialise/1" do
    for op <- ~w[* / + - == != < <= > >= && || ^]a do
      quote do
        test "when the operator is `#{unquote(op)}` it serialises correctly" do
          ok(lhs) = Integer.init(1)
          ok(rhs) = Integer.init(2)
          ok(unary) = Binary.init(unquote(op), lhs, rhs)
          as_s = to_string(unquote(op))
          assert ok(["1", as_s, "2"]) = Serialise.serialise(unary)
        end
      end
    end
  end
end
