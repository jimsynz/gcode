defmodule InfixHelper do
  alias Gcode.Model.{Expr, Expr.Binary}
  use Gcode.Result
  @moduledoc false

  @type value :: boolean | integer | float | String.t()

  @spec cast_expression(value) :: Result.t(Expr.t())
  def cast_expression(value) when is_integer(value), do: Expr.Integer.init(value)
  def cast_expression(value) when is_float(value), do: Expr.Float.init(value)
  def cast_expression(value) when is_boolean(value), do: Expr.Boolean.init(value)
  def cast_expression(value) when is_binary(value), do: Expr.String.init(value)

  @spec it_evaluates_to(atom, value, value, any) :: Macro.t()
  defmacro it_evaluates_to(op, lhs, rhs, result) do
    quote do
      test "when the operator is `#{unquote(op)}` and the lhs is `#{inspect(unquote(lhs))}` and the rhs is `#{
             inspect(unquote(rhs))
           }` it is correct" do
        ok(lhs) = InfixHelper.cast_expression(unquote(lhs))
        ok(rhs) = InfixHelper.cast_expression(unquote(rhs))
        ok(bin) = Binary.init(unquote(op), lhs, rhs)

        assert unquote(result) = Expr.evaluate(bin)
      end
    end
  end
end
