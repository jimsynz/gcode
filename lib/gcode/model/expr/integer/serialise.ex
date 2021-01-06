defimpl Gcode.Model.Serialise, for: Gcode.Model.Expr.Integer do
  alias Gcode.Model.Expr.Integer
  use Gcode.Result

  @moduledoc """
  Implement the `Serialise` protocol for `Integer`, allowing them to be
  convered into G-code output.
  """

  @spec serialise(Integer.t()) :: Result.t([String.t()], {:serialise_error, any})
  def serialise(%Integer{i: value}) when is_integer(value),
    do: ok([Elixir.Integer.to_string(value)])

  def serialise(_), do: error({:serialise_error, "Invalid integer"})
end
