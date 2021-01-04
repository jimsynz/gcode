defprotocol Gcode.Model.Serialise do
  alias Gcode.Result

  @moduledoc """
  A protocol which is used to serialise the model into a string.
  """

  @spec serialise(Serialise.t()) :: Result.t([String.t()])
  def serialise(value)
end