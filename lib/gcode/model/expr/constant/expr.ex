defimpl Gcode.Model.Expr, for: Gcode.Model.Expr.Constant do
  alias Gcode.Model.Expr
  alias Gcode.Model.Expr.Constant
  use Gcode.Result

  @moduledoc """
  Implements the `Expr` protocol for `Constant`, which will return either true
  or false.

  Currently only knows how to evaluate the following constants:

    * `pi` evaluates to the result of `:math.pi()`
    * `null` evaulates to `nil`

  Other constants cannot be evaluated at this time, because they need to
  understand the machine state.
  """

  @spec evaluate(Constant.t()) :: Expr.result()
  def evaluate(%Constant{name: :pi}), do: ok(:math.pi())
  def evaluate(%Constant{name: :null}), do: ok(nil)

  def evaluate(%Constant{name: name}),
    do: error({:program_error, "Unable to evaluate constant `#{name}`"})
end
