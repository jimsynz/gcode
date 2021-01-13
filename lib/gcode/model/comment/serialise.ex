defimpl Gcode.Model.Serialise, for: Gcode.Model.Comment do
  alias Gcode.Model.Comment
  use Gcode.Option
  use Gcode.Result

  @moduledoc """
  Implements the `Serialise` protocol for `Comment`, allowing it to be turned
  into G-code output.
  """

  @spec serialise(Comment.t()) :: Result.t([String.t()], {:serialise_error, any})
  def serialise(%Comment{comment: comment}) when is_binary(comment) do
    comment
    |> String.split(~r/(\r\n|\r|\n)/)
    |> Enum.reject(&(byte_size(&1) == 0))
    |> Enum.map(&"(#{&1})")
    |> ok()
  end

  def serialise(_comment), do: error({:serialise_error, "Invalid comment"})
end
