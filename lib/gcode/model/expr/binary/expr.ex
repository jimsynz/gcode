defimpl Gcode.Model.Expr, for: Gcode.Model.Expr.Binary do
  alias Gcode.Model.{Expr, Expr.Binary}
  use Gcode.Option
  use Gcode.Result

  @moduledoc """
  Implements the `Expr` protocol for `Binary`, which will try and perform the
  infix calculation to the best of it's ability.
  """

  @spec evaluate(Binary.t()) :: Expr.result()
  def evaluate(%Binary{op: some(op), lhs: some(lhs), rhs: some(rhs)}) do
    with ok(lhs) <- Expr.evaluate(lhs),
         ok(rhs) <- Expr.evaluate(rhs),
         do: do_evaluate(op, lhs, rhs)
  end

  def evaluate(_binary), do: error({:program_error, "Unable to evaluate binary expression"})

  defp do_evaluate(:*, lhs, rhs) when is_integer(lhs) and is_integer(rhs), do: ok(lhs * rhs)
  defp do_evaluate(:*, lhs, rhs) when is_float(lhs) and is_float(rhs), do: ok(lhs * rhs)

  defp do_evaluate(:*, lhs, rhs),
    do:
      error(
        {:program_error,
         "Both sides of a multiplication expression must be the same type, and either integers or floats. Received #{inspect(lhs: lhs, rhs: rhs)}"}
      )

  defp do_evaluate(:/, lhs, rhs) when is_float(lhs) and is_float(rhs), do: ok(lhs / rhs)

  defp do_evaluate(:/, lhs, rhs),
    do:
      error(
        {:program_error,
         "Both sides of a division expression must be the floats. Received #{inspect(lhs: lhs, rhs: rhs)}"}
      )

  defp do_evaluate(:+, lhs, rhs) when is_integer(lhs) and is_integer(rhs), do: ok(lhs + rhs)
  defp do_evaluate(:+, lhs, rhs) when is_float(lhs) and is_float(rhs), do: ok(lhs + rhs)

  defp do_evaluate(:+, lhs, rhs),
    do:
      error(
        {:program_error,
         "Both sides of an addition expression must be the same type, and either integers or floats. Received #{inspect(lhs: lhs, rhs: rhs)}"}
      )

  defp do_evaluate(:-, lhs, rhs) when is_integer(lhs) and is_integer(rhs), do: ok(lhs - rhs)
  defp do_evaluate(:-, lhs, rhs) when is_float(lhs) and is_float(rhs), do: ok(lhs - rhs)

  defp do_evaluate(:-, lhs, rhs),
    do:
      error(
        {:program_error,
         "Both sides of a subtraction expression must be the same type, and either integers or floats. Received #{inspect(lhs: lhs, rhs: rhs)}"}
      )

  defp do_evaluate(:==, lhs, rhs) when is_integer(lhs) and is_integer(rhs), do: ok(lhs == rhs)
  defp do_evaluate(:==, lhs, rhs) when is_float(lhs) and is_float(rhs), do: ok(lhs == rhs)
  defp do_evaluate(:==, lhs, rhs) when is_binary(lhs) and is_binary(rhs), do: ok(lhs == rhs)

  defp do_evaluate(:==, lhs, rhs),
    do:
      error(
        {:program_error,
         "Both sides of an equality expression must be the same type, and either integers, floats or strings. Received #{inspect(lhs: lhs, rhs: rhs)}"}
      )

  defp do_evaluate(:!=, lhs, rhs) when is_integer(lhs) and is_integer(rhs), do: ok(lhs != rhs)
  defp do_evaluate(:!=, lhs, rhs) when is_float(lhs) and is_float(rhs), do: ok(lhs != rhs)
  defp do_evaluate(:!=, lhs, rhs) when is_binary(lhs) and is_binary(rhs), do: ok(lhs != rhs)

  defp do_evaluate(:!=, lhs, rhs),
    do:
      error(
        {:program_error,
         "Both sides of an inequality expression must be the same type, and either integers, floats or strings. Received #{inspect(lhs: lhs, rhs: rhs)}"}
      )

  defp do_evaluate(:<, lhs, rhs) when is_integer(lhs) and is_integer(rhs), do: ok(lhs < rhs)
  defp do_evaluate(:<, lhs, rhs) when is_float(lhs) and is_float(rhs), do: ok(lhs < rhs)

  defp do_evaluate(:<, lhs, rhs),
    do:
      error(
        {:program_error,
         "Both sides of an LT expression must be the same type, and either integers or floats. Received #{inspect(lhs: lhs, rhs: rhs)}"}
      )

  defp do_evaluate(:<=, lhs, rhs) when is_integer(lhs) and is_integer(rhs), do: ok(lhs <= rhs)
  defp do_evaluate(:<=, lhs, rhs) when is_float(lhs) and is_float(rhs), do: ok(lhs <= rhs)

  defp do_evaluate(:<=, lhs, rhs),
    do:
      error(
        {:program_error,
         "Both sides of an LTE expression must be the same type, and either integers or floats. Received #{inspect(lhs: lhs, rhs: rhs)}"}
      )

  defp do_evaluate(:>, lhs, rhs) when is_integer(lhs) and is_integer(rhs), do: ok(lhs > rhs)
  defp do_evaluate(:>, lhs, rhs) when is_float(lhs) and is_float(rhs), do: ok(lhs > rhs)

  defp do_evaluate(:>, lhs, rhs),
    do:
      error(
        {:program_error,
         "Both sides of an GT expression must be the same type, and either integers or floats. Received #{inspect(lhs: lhs, rhs: rhs)}"}
      )

  defp do_evaluate(:>=, lhs, rhs) when is_integer(lhs) and is_integer(rhs), do: ok(lhs >= rhs)
  defp do_evaluate(:>=, lhs, rhs) when is_float(lhs) and is_float(rhs), do: ok(lhs >= rhs)

  defp do_evaluate(:>=, lhs, rhs),
    do:
      error(
        {:program_error,
         "Both sides of an GTE expression must be the same type, and either integers or floats. Received #{inspect(lhs: lhs, rhs: rhs)}"}
      )

  defp do_evaluate(:&&, lhs, rhs) when is_boolean(lhs) and is_boolean(rhs), do: ok(lhs && rhs)

  defp do_evaluate(:&&, lhs, rhs),
    do:
      error(
        {:program_error,
         "Both sides of a logical and expression must be booleans. Received #{inspect(lhs: lhs, rhs: rhs)}"}
      )

  defp do_evaluate(:||, lhs, rhs) when is_boolean(lhs) and is_boolean(rhs), do: ok(lhs || rhs)

  defp do_evaluate(:||, lhs, rhs),
    do:
      error(
        {:program_error,
         "Both sides of a logical or expression must be booleans. Received #{inspect(lhs: lhs, rhs: rhs)}"}
      )

  defp do_evaluate(:^, lhs, rhs) when is_binary(lhs) and is_binary(rhs), do: ok(lhs <> rhs)

  defp do_evaluate(:^, lhs, rhs),
    do:
      error(
        {:program_error,
         "Both sides of a string concatenation must be strings. Received #{inspect(lhs: lhs, rhs: rhs)}"}
      )

  defp do_evaluate(op, lhs, rhs),
    do:
      error({:program_error, "Invalid infix expression. #{inspect(op: op, lhs: lhs, rhs: rhs)}"})
end
