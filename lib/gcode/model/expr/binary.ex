defmodule Gcode.Model.Expr.Binary do
  use Gcode.Option
  defstruct op: none(), lhs: none(), rhs: none()
  alias Gcode.Model.{Expr, Expr.Binary}
  import Gcode.Model.Expr.Helpers
  use Gcode.Result

  @moduledoc """
  Represents a binary (or infix) expression in G-code, consisting of two
  operands (`lhs` and `rhs`) and an operator to apply.
  """

  @operators ~w[* / + - == != < <= > >= && || ^]a

  @typedoc "Valid infix operators"
  @type operator :: :* | :/ | :+ | :- | :== | :!= | :< | :<= | :> | :>= | :&& | :|| | :^

  @type t :: %Binary{op: Option.t(operator), lhs: Option.t(Expr.t()), rhs: Option.t(Expr.t())}

  @doc """
  Wrap an operator and two expressions in a binary expression.
  """
  @spec init(operator, Expr.t(), Expr.t()) :: Result.t(t)
  def init(operator, lhs, rhs)
      when operator in @operators and is_expression(lhs) and is_expression(rhs),
      do: ok(%Binary{op: some(operator), lhs: some(lhs), rhs: some(rhs)})

  def init(operator, lhs, rhs),
    do:
      error(
        {:expression_error,
         "Expected an operator and two expressions, but received #{inspect(operator: operator, lhs: lhs, rhs: rhs)}"}
      )
end
