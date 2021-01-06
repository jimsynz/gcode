defimpl Gcode.Model.Serialise, for: Gcode.Model.Expr.Binary do
  alias Gcode.Model.{Expr.Binary, Serialise}
  use Gcode.Option
  use Gcode.Result

  @moduledoc """
  Implement the `Serialise` protocol for `Binary`, allowing them to be convered
  into G-code output.
  """

  @spec serialise(Binary.t()) :: Serialise.result()
  def serialise(%Binary{op: some(op), lhs: some(lhs), rhs: some(rhs)}) do
    with ok(lhs) <- Serialise.serialise(lhs),
         ok(rhs) <- Serialise.serialise(rhs) do
      ok([lhs, to_string(op), rhs])
    end
  end
end
