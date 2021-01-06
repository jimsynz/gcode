defmodule Gcode.Model.Expr.Boolean.SerialiseTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Expr.Boolean, Serialise}
  use Gcode.Result
  @moduledoc false

  describe "Serialise.serialise/1" do
    test "when the value is `true` it is serialised to `\"true\"`" do
      ok(bool) = Boolean.init(true)
      assert ok(["true"]) = Serialise.serialise(bool)
    end

    test "when the value is `false` it is serialised to `\"false\"`" do
      ok(bool) = Boolean.init(false)
      assert ok(["false"]) = Serialise.serialise(bool)
    end
  end
end
