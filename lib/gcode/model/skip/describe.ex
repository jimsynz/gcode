defimpl Gcode.Model.Describe, for: Gcode.Model.Skip do
  alias Gcode.Model.Skip
  use Gcode.Option

  @spec describe(Skip.t(), options :: []) :: Option.t(String.t())
  def describe(_skip, _opts \\ []), do: none()
end
