defimpl Gcode.Model.Describe, for: Gcode.Model.Tape do
  alias Gcode.Model.Tape
  use Gcode.Option

  @moduledoc """
  Implements the `Describe` protocol for `Tape`.
  """

  @spec describe(Tape.t(), options :: []) :: Option.t(String.t())
  def describe(_tape, _opts \\ []), do: none()
end
