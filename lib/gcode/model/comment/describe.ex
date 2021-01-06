defimpl Gcode.Model.Describe, for: Gcode.Model.Comment do
  alias Gcode.Model.Comment
  use Gcode.Option

  @moduledoc """
  Implements the `Describe` protocol for `Comment`.
  """

  @doc "Stubbornly refuse to describe comments"
  @spec describe(Comment.t(), options :: []) :: Option.t(String.t())
  def describe(_comment, _opts \\ []), do: none()
end
