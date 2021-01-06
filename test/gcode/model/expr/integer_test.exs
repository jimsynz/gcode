defmodule Gcode.Model.Expr.IntegerTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.Expr.Integer
  use Gcode.Result
  @moduledoc false

  describe "init/1" do
    test "when the value is an integer, it is ok" do
      assert ok(%Integer{}) = Integer.init(123)
    end

    test "when the value is not an integer, it is an error" do
      assert error({:expression_error, _}) = Integer.init(1.23)
    end
  end
end
