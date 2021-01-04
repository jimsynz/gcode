defmodule Gcode do
  alias Gcode.{Model.Program, Model.Serialise, Result}

  @moduledoc """
  Documentation for `Gcode`.
  """

  @doc """
  Serialise a program to a String.
  """
  @spec serialise(Program.t()) :: Result.t(String.t(), {:serialise_error, any})
  def serialise(%Program{} = program) do
    program
    |> Serialise.serialise()
    |> Result.Enum.map(fn block ->
      {:ok, "#{block}\r\n"}
    end)
    |> Result.Enum.join("")
  end
end
