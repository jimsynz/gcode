defmodule Gcode.Model.Expr.Unary do
  use Gcode.Option
  defstruct op: none(), expr: none()
  alias Gcode.Model.{Expr, Expr.Unary}
  import Gcode.Model.Expr.Helpers
  use Gcode.Result

  @moduledoc """
  Represents a unary (or prefix) expression in G-code.  A unary consists of a
  single operand and an operator.
  """

  @operators ~w[! + - #]a

  @typedoc "Valid unary operators"
  @type operator :: :! | :+ | :- | :"#"

  @type t :: %Unary{op: Option.t(atom), expr: Option.t(Expr.t())}

  @doc """
  Wrap an inner expression and operator in a unary expression.
  """
  @spec init(operator, Expr.t()) :: Result.t(t)
  def init(operator, expr) when operator in @operators and is_expression(expr),
    do: ok(%Unary{op: some(operator), expr: some(expr)})

  def init(operator, expr) when operator in @operators,
    do: error({:expression_error, "Expected expression, but received #{inspect(expr)}"})

  def init(operator, expr) when is_expression(expr),
    do: error({:expression_error, "Expected unary operator, but received #{inspect(operator)}"})

  def init(operator, expr),
    do:
      error(
        {:expression_error,
         "Expected unary operator and expression, but received #{inspect(operator: operator, expression: expr)}"}
      )
end
