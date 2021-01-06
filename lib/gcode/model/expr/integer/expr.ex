defimpl Gcode.Model.Expr, for: Gcode.Model.Expr.Integer do
  alias Gcode.Model.Expr
  alias Gcode.Model.Expr.Integer
  use Gcode.Result

  @moduledoc """
  Implements the `Expr` protocol for `Integer`, which will return evaluate to a
  integer.
  """

  @spec evaluate(Integer.t()) :: Expr.result()
  def evaluate(%Integer{i: i}), do: ok(i)
end
