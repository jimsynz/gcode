defprotocol Gcode.Model.Describe do
  alias Gcode.Model.Describe
  use Gcode.Option

  @moduledoc """
  A protocol which is used to describe the model for human consumption.
  """

  @spec describe(Describe.t(), options :: []) :: Option.t(String.t())
  def describe(describable, opts \\ [])
end
