defmodule Gcode.Model.Expr.Integer do
  defstruct i: 0
  alias Gcode.Model.Expr.Integer
  use Gcode.Result

  @moduledoc """
  Represents an integer number expression in G-code.
  """

  @type t :: %Integer{i: integer}

  @spec init(integer) :: Result.t(t)
  def init(value) when is_integer(value),
    do: ok(%Integer{i: value})

  def init(value),
    do: error({:expression_error, "Expected an integer value, but received #{inspect(value)}"})
end
