defmodule Gcode.Model.Expr.ConstantTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.Expr.Constant
  use Gcode.Result
  @moduledoc false

  describe "init/1" do
    for name <- ~w[iterations line null pi result]a do
      quote do
        test "when the argument is `#{unquote(name)}`, it is ok" do
          assert ok(%Constant{name: unquote(name)}) = Constant.init(unquote(name))
        end
      end
    end

    test "otherwise, it is an error" do
      assert error(_) = Constant.init(:wat)
    end
  end
end
