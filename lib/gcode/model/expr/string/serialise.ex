defimpl Gcode.Model.Serialise, for: Gcode.Model.Expr.String do
  alias Gcode.Model.Expr.String
  use Gcode.Result

  @moduledoc """
  Implement the `Serialise` protocol for `String`, allowing them to be converted
  into G-code output.
  """

  @spec serialise(String.t()) :: Result.t([Elixir.String.t()], {:serialise_error, any})
  def serialise(%String{value: value}), do: ok([inspect(value)])
end
