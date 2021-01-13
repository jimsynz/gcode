defmodule Gcode do
  alias Gcode.{Model.Program, Model.Serialise}
  use Gcode.Result

  @moduledoc """
  Gcode - a library for parsing and serialising G-code.

  If you haven't heard of G-code before, then you probably don't need this
  library, but if you're working with CNC machines or 3D printers then G-code is
  the defacto standard for working with these machines.  As such it behoves us
  to have first class support for working with G-code in Elixir.

  You're welcome.

  For functions related to parsing G-code files and commands, see the `Parser`
  module.  For generating your own programs see the contents of `Model`, and for
  converting programs back into G-code see the `Model.Serialise` protocol.
  """

  @doc """
  Serialise a program to a String.
  """
  @spec serialise(Program.t()) :: Result.t(String.t(), {:serialise_error, any})
  def serialise(%Program{} = program) do
    program
    |> Serialise.serialise()
    |> Result.Enum.map(&ok("#{&1}\r\n"))
    |> Result.Enum.join("")
  end
end
