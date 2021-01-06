defmodule Gcode.Model.Expr.Helpers do
  alias Gcode.Model.Expr

  @moduledoc """
  Helpers for working with expressions.
  """

  @doc """
  A guard which ensures that `value` is an expression struct.
  """
  @spec is_expression(any) :: Macro.t()
  defguard is_expression(value)
           when is_struct(value, Expr.Binary) or is_struct(value, Expr.Boolean) or
                  is_struct(value, Expr.Constant) or is_struct(value, Expr.Float) or
                  is_struct(value, Expr.Integer) or is_struct(value, Expr.List) or
                  is_struct(value, Expr.String) or is_struct(value, Expr.Unary)
end
