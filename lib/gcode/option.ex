defmodule Gcode.Option do
  @moduledoc """
  A helper which represents an optional type.
  """

  defmacro __using__(_) do
    quote do
      alias Gcode.Option
      require Gcode.Option
      import Gcode.Option, only: [some: 1, none: 0]
    end
  end

  @type t(value) :: some(value) | opt_none
  @type some(t) :: {:ok, t}
  @type opt_none :: :none

  @spec none?(t(any)) :: boolean
  def none?(:none), do: true
  def none?({:ok, _}), do: false

  @spec some?(t(any)) :: boolean
  def some?(:none), do: false
  def some?({:ok, _}), do: true

  @spec none :: Macro.t()
  defmacro none do
    quote do
      :none
    end
  end

  @spec some(any) :: Macro.t()
  defmacro some(pattern) do
    quote do
      {:ok, unquote(pattern)}
    end
  end
end