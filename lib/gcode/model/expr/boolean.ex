defmodule Gcode.Model.Expr.Boolean do
  defstruct b: false
  alias Gcode.Model.Expr.Boolean
  use Gcode.Result

  @moduledoc """
  Represents a boolean expression in G-code.  Can be either `true` or `false`.
  """

  @type t :: %Boolean{b: boolean}

  @doc """
  Initialise a `Boolean` from a boolean value.
  """
  @spec init(boolean) :: Result.t(t)
  def init(value) when is_boolean(value),
    do: ok(%Boolean{b: value})

  def init(value),
    do: error({:expression_error, "Expected a boolean value, instead received #{inspect(value)}"})
end
