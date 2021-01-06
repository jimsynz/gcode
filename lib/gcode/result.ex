defmodule Gcode.Result do
  @moduledoc """
  A helper which represents a result type.

  This is really just a wrapper around Erlang's ok/error tuples.
  """

  @type t :: t(any, any)
  @type t(result) :: t(result, any)
  @type t(result, error) :: ok(result) | error(error)
  @type ok(result) :: {:ok, result}
  @type error(error) :: {:error, error}

  @spec __using__(any) :: Macro.t()
  defmacro __using__(_) do
    quote do
      alias Gcode.Result
      require Gcode.Result
      import Gcode.Result, only: [ok: 1, error: 1]
    end
  end

  @doc "Initialise or match an ok value"
  @spec ok(any) :: Macro.t()
  defmacro ok(result) do
    quote do
      {:ok, unquote(result)}
    end
  end

  @doc "Initialise or match an error value"
  @spec error(any) :: Macro.t()
  defmacro error(error) do
    quote do
      {:error, unquote(error)}
    end
  end

  @doc "Is the result ok?"
  @spec ok?(t) :: boolean
  def ok?({:ok, _}), do: true
  def ok?({:error, _}), do: false

  @doc "Is the result an error?"
  @spec error?(t) :: boolean
  def error?({:ok, _}), do: false
  def error?({:error, _}), do: true

  @doc "Attempt to unwrap a result and return the inner value.  Raises an exception if the result contains an error."
  @spec unwrap!(t) :: any | no_return
  def unwrap!({:ok, result}), do: result
  def unwrap!({:error, error}), do: raise(error)

  @doc "Convert a successful result another result."
  @spec map(t, (any -> t)) :: t
  def map({:ok, value}, mapper) when is_function(mapper, 1) do
    case mapper.(value) do
      {:ok, value} -> {:ok, value}
      {:error, error} -> {:error, error}
    end
  end

  def map({:error, value}, mapper) when is_function(mapper, 1), do: {:error, value}
end
