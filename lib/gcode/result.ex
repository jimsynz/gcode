defmodule Gcode.Result do
  @moduledoc """
  A helper which represents a result type.
  """

  @type t :: t(any, any)
  @type t(result) :: t(result, any)
  @type t(result, error) :: ok(result) | error(error)
  @type ok(result) :: {:ok, result}
  @type error(error) :: {:error, error}

  defmacro __using__(_) do
    quote do
      alias Gcode.Result
      require Gcode.Result
      import Gcode.Result, only: [ok: 1, error: 1]
    end
  end

  @spec ok(any) :: Macro.t()
  defmacro ok(result) do
    quote do
      {:ok, unquote(result)}
    end
  end

  @spec error(any) :: Macro.t()
  defmacro error(error) do
    quote do
      {:error, unquote(error)}
    end
  end

  @spec ok?(t) :: boolean
  def ok?({:ok, _}), do: true
  def ok?({:error, _}), do: false

  @spec error?(t) :: boolean
  def error?({:ok, _}), do: false
  def error?({:error, _}), do: true

  @spec unwrap!(t) :: any | no_return
  def unwrap!({:ok, result}), do: result
  def unwrap!({:error, error}), do: raise(error)

  @spec map(t, (any -> t)) :: t
  def map({:ok, value}, mapper) when is_function(mapper, 1) do
    case mapper.(value) do
      {:ok, value} -> {:ok, value}
      {:error, error} -> {:error, error}
    end
  end

  def map({:error, value}, mapper) when is_function(mapper, 1), do: {:error, value}
end
