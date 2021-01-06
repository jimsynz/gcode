defmodule Gcode.Model.Expr.Float do
  defstruct f: 0.0
  alias Gcode.Model.Expr.Float
  use Gcode.Result

  @moduledoc """
  Represents a floating-point number expression in G-code.
  """

  @type t :: %Float{f: float}

  @doc """
  Initialise a `Float` from a floating-point value.
  """
  @spec init(float) :: Result.t(t)
  def init(value) when is_float(value),
    do: ok(%Float{f: value})

  def init(value),
    do: error({:expression_error, "Expected a float value, instead received #{inspect(value)}"})
end
