defimpl Gcode.Model.Describe, for: Gcode.Model.Comment do
  alias Gcode.Model.Comment
  use Gcode.Option

  @spec describe(Comment.t(), options :: []) :: Option.t(String.t())
  def describe(_comment, _opts \\ []), do: none()
end
