defimpl Gcode.Model.Serialise, for: Gcode.Model.Skip do
  alias Gcode.{Model.Skip, Result}
  use Gcode.Option
  use Gcode.Result
  @moduledoc false

  @spec serialise(Skip.t()) :: Result.t([String.t()], {:serialise_error, any})
  def serialise(%Skip{number: none()}), do: ok(["/"])
  def serialise(%Skip{number: some(number)}), do: ok(["/#{number}"])
end
