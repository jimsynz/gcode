defimpl Gcode.Model.Serialise, for: Gcode.Model.Tape do
  alias Gcode.{Model.Tape, Result}
  use Gcode.Option
  use Gcode.Result

  @moduledoc """
  Implements the `Serialise` protocol for `Tape`, allowing it to be turned into
  G-code output.
  """

  @spec serialise(Tape.t()) :: Result.t([String.t()], {:serialise_error, any})
  def serialise(%Tape{leader: none()}), do: ok(["%"])
  def serialise(%Tape{leader: some(leader)}), do: ok(["% #{leader}"])
end
