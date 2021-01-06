defimpl Gcode.Model.Serialise, for: Gcode.Model.Expr.Boolean do
  alias Gcode.Model.Expr.Boolean
  use Gcode.Result

  @moduledoc """
  Implement the `Serialise` protocol for `Boolean`, allowing them to be convered
  into G-code output.
  """

  @spec serialise(Boolean.t()) :: Result.t([String.t()], {:serialise_error, any})
  def serialise(%Boolean{b: true}), do: ok(["true"])
  def serialise(%Boolean{b: false}), do: ok(["false"])
  def serialise(_), do: error({:serialise_error, "Invalid boolean"})
end
