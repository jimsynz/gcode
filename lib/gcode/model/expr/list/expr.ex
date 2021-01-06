defimpl Gcode.Model.Expr, for: Gcode.Model.Expr.List do
  alias Gcode.Model.{Expr, Expr.List}
  use Gcode.Result

  @moduledoc """
  Implements the `Expr` protocol for `List`, which will return evaluate to a
  list.
  """

  @spec evaluate(List.t()) :: Expr.result()
  def evaluate(%List{elements: elements}) do
    elements =
      elements
      |> Enum.map(&Expr.evaluate/1)

    ok(elements)
  end
end
