defimpl Gcode.Model.Serialise, for: Gcode.Model.Expr.List do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Expr.List, Serialise}
  use Gcode.Result
  @moduledoc false

  describe "Serialise.serialise/1" do
    test "it cannot be serialised" do
      ok(list) = List.init()
      assert error(_) = Serialise.serialise(list)
    end
  end
end
