defmodule Gcode.Model.Expr.FloatTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.Expr.Float
  use Gcode.Result
  @moduledoc false

  describe "init/1" do
    test "when the value is a float, it is ok" do
      assert ok(%Float{}) = Float.init(1.23)
    end

    test "when the value is not a float, it is an error" do
      assert error({:expression_error, _}) = Float.init(123)
    end
  end
end
