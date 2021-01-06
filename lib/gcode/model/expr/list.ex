defmodule Gcode.Model.Expr.List do
  defstruct elements: []
  alias Gcode.Model.{Expr, Expr.List}
  use Gcode.Result
  import Gcode.Model.Expr.Helpers

  @moduledoc """
  Represents an array expression in G-code.
  """

  @type t :: %List{elements: [Expr.t()]}

  @doc """
  Initialise a `List` from a boolean value.
  """
  @spec init :: Result.t(t)
  def init, do: ok(%List{})

  @doc """
  Push an expressions onto the list.
  """
  @spec push(t, Expr.t()) :: Result.t(t)
  def push(%List{elements: elements}, expr) when is_expression(expr),
    do: ok(%List{elements: [expr | elements]})

  def push(%List{}, expr),
    do: error({:expression_error, "Expected expression, but received #{inspect(expr)}"})
end
