defmodule Gcode.Model.Expr.BinaryTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.Expr.{Binary, Integer}
  use Gcode.Option
  use Gcode.Result
  @moduledoc false

  describe "init/3" do
    test "when the operator and expressions are valid, it is ok" do
      ok(lhs) = Integer.init(1)
      ok(rhs) = Integer.init(2)

      assert ok(%Binary{op: some(:-), lhs: some(^lhs), rhs: some(^rhs)}) =
               Binary.init(:-, lhs, rhs)
    end
  end
end
