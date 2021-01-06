defimpl Gcode.Model.Serialise, for: Gcode.Model.Expr.Float do
  alias Gcode.Model.Expr.Float
  use Gcode.Result

  @moduledoc """
  Implement the `Serialise` protocol for `Float`, allowing them to be
  convered into G-code output.
  """

  @spec serialise(Float.t()) :: Result.t([String.t()], {:serialise_error, any})
  def serialise(%Float{f: value}) when is_float(value), do: ok([Elixir.Float.to_string(value)])
  def serialise(_), do: error({:serialise_error, "Invalid float"})
end
