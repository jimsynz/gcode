defprotocol Gcode.Model.Expr do
  use Gcode.Result
  alias Gcode.Model.Expr

  @moduledoc """
  A protocol for evaluating expressions.
  """

  @type scalar :: number | boolean | String.t()
  @type expr :: scalar | [scalar]
  @type result :: Result.t(expr)

  @spec evaluate(Expr.t()) :: result
  def evaluate(_expr)
end
