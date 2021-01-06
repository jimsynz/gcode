defmodule Gcode.Model.Expr.BooleanTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.Expr.Boolean
  use Gcode.Result
  @moduledoc false

  describe "init/1" do
    test "when the argument is `true` it is ok" do
      assert ok(%Boolean{}) = Boolean.init(true)
    end

    test "when the argument is `false` it is ok" do
      assert ok(%Boolean{}) = Boolean.init(false)
    end

    test "when passed any other argument, it fails" do
      assert error({:expression_error, _}) = Boolean.init(nil)
    end
  end
end
