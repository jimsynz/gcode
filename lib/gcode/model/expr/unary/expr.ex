defimpl Gcode.Model.Expr, for: Gcode.Model.Expr.Unary do
  alias Gcode.Model.{Expr, Expr.Unary}
  use Gcode.Option
  use Gcode.Result

  @moduledoc """
  Implements the `Expr` protocol for `Unary`, which will attempt to apply the
  operator to the operand.
  """

  @spec evaluate(Unary.t()) :: Expr.result()
  def evaluate(%Unary{op: some(:!), expr: some(inner)}) do
    case Expr.evaluate(inner) do
      ok(result) when is_boolean(result) ->
        ok(!result)

      ok(other) ->
        error(
          {:program_error,
           "Expected expression to evaulate to boolean, but received #{inspect(other)}"}
        )

      error(result) ->
        error(result)
    end
  end

  def evaluate(%Unary{op: some(:-), expr: some(inner)}) do
    case Expr.evaluate(inner) do
      ok(result) when is_number(result) ->
        ok(0 - result)

      ok(other) ->
        error(
          {:program_error,
           "Expected expression to evaluate to a number, but received #{inspect(other)}"}
        )

      error(reason) ->
        error(reason)
    end
  end

  def evaluate(%Unary{op: some(:+), expr: some(inner)}) do
    case Expr.evaluate(inner) do
      ok(result) when is_number(result) ->
        ok(0 + result)

      ok(other) ->
        error(
          {:program_error,
           "Expected expression to evaluate to a number, but received #{inspect(other)}"}
        )

      error(reason) ->
        error(reason)
    end
  end

  def evaluate(%Unary{op: some(:"#"), expr: some(inner)}) do
    case Expr.evaluate(inner) do
      ok(result) when is_list(result) ->
        ok(length(result))

      ok(result) when is_binary(result) ->
        ok(String.length(result))

      ok(other) ->
        error(
          {:program_error,
           "Expected expression to evaluate to an array or string, but received #{inspect(other)}"}
        )

      error(reason) ->
        error(reason)
    end
  end
end
