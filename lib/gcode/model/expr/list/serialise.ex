defimpl Gcode.Model.Serialise, for: Gcode.Model.Expr.List do
  alias Gcode.Model.{Expr.List, Serialise}
  use Gcode.Result

  @moduledoc """
  Implement the `Serialise` protocol for `List`.  Unfortunately it's impossible
  to serialise a list into G-code.
  """

  @spec serialise(List.t()) :: Serialise.result()
  def serialise(%List{}), do: error({:serialise_error, "Cannot serialise a list"})
end
