defimpl Gcode.Model.Expr, for: Gcode.Model.Expr.Float do
  alias Gcode.Model.Expr
  alias Gcode.Model.Expr.Float
  use Gcode.Result

  @moduledoc """
  Implements the `Expr` protocol for `Float`, which will return evaluate to a
  float.
  """

  @spec evaluate(Float.t()) :: Expr.result()
  def evaluate(%Float{f: f}), do: ok(f)
end
