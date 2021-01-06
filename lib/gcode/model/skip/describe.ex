defimpl Gcode.Model.Describe, for: Gcode.Model.Skip do
  alias Gcode.Model.Skip
  use Gcode.Option

  @moduledoc """
  Implements the `Describe` protocol for `Skip`.
  """

  @spec describe(Skip.t(), options :: []) :: Option.t(String.t())
  def describe(_skip, _opts \\ []), do: none()
end
