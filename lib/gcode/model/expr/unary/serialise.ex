defimpl Gcode.Model.Serialise, for: Gcode.Model.Expr.Unary do
  alias Gcode.Model.{Expr.Unary, Serialise}
  use Gcode.Option
  use Gcode.Result

  @moduledoc """
  Implement the `Serialise` protocol for `Unary`, allowing them to be converted
  into G-code output.
  """

  @spec serialise(Unary.t()) :: Serialise.result()
  def serialise(%Unary{op: some(op), expr: some(inner)}) do
    case Serialise.serialise(inner) do
      ok(inner) -> ok([to_string(op) | inner])
      error(reason) -> error(reason)
    end
  end

  def serialise(unary),
    do: error({:serialise_error, "Invalid unary: #{inspect(unary)}"})
end
