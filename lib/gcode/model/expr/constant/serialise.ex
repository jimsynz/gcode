defimpl Gcode.Model.Serialise, for: Gcode.Model.Expr.Constant do
  alias Gcode.Model.Expr.Constant
  use Gcode.Result

  @moduledoc """
  Implement the `Serialise` protocol for `Constant`, allowing them to be
  convered into G-code output.
  """

  @spec serialise(Constant.t()) :: Result.t([String.t()], {:serialise_error, any})
  def serialise(%Constant{name: name}), do: ok([to_string(name)])
end
