defimpl Gcode.Model.Expr, for: Gcode.Model.Expr.String do
  alias Gcode.Model.Expr
  alias Gcode.Model.Expr.String
  use Gcode.Result

  @moduledoc """
  Implements the `Expr` protocol for `String`, which will return evaluate to an
  Erlang binary.
  """

  @spec evaluate(String.t()) :: Expr.result()
  def evaluate(%String{value: value}), do: ok(value)
end
