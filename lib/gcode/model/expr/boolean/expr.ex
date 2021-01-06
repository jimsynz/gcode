defimpl Gcode.Model.Expr, for: Gcode.Model.Expr.Boolean do
  alias Gcode.Model.Expr
  alias Gcode.Model.Expr.Boolean
  use Gcode.Result

  @moduledoc """
  Implements the `Expr` protocol for `Boolean`, which will return either true or
  false.
  """

  @spec evaluate(Boolean.t()) :: Expr.result()
  def evaluate(%Boolean{b: b}), do: ok(b)
end
