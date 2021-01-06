defmodule Gcode.Model.Expr.Constant do
  use Gcode.Option
  use Gcode.Result
  defstruct name: none()
  alias Gcode.Model.Expr.Constant

  @moduledoc """
  Represents a number of special constant values defined by some G-code
  controllers:

    * `iterations` - the number of completed iterations of the innermost loop.
    * `line` - the current line number in the file being executed.
    * `null` - the null object.
    * `pi` - the constant π.
    * `result` - 0 if the last G-, M- or T-command on this input channel was
      successful, 1 if it returned a warning, 2 if it returned an error.
  """

  @type constant :: :iterations | :line | :null | :pi | :result
  @type t :: %Constant{name: Option.t(constant)}

  @doc """
  Initialise a `Constant`.
  """
  def init(name) when name in ~w[iterations line null pi result]a,
    do: ok(%Constant{name: name})

  def init(name),
    do:
      error({:expression_error, "Expected a valid constant name, but received #{inspect(name)}"})
end
