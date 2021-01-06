defimpl Gcode.Model.Serialise, for: Gcode.Model.Program do
  alias Gcode.{Model.Program, Model.Serialise}
  use Gcode.Result

  @moduledoc """
  Implements the `Serialise` protocol for `Program`, allowing it to be turned
  into G-code output.
  """

  @spec serialise(Program.t()) :: Result.t([String.t()], {:serialise_error, any})
  def serialise(%Program{elements: elements}) do
    with elements <- Enum.reverse(elements),
         ok(result) <- Result.Enum.map(ok(elements), &Serialise.serialise/1) do
      ok(List.flatten(result))
    end
  end
end
