defimpl Gcode.Model.Serialise, for: Gcode.Model.Comment do
  alias Gcode.Model.Comment
  use Gcode.Option
  use Gcode.Result

  @spec serialise(Comment.t()) :: Result.t([String.t()], {:serialise_error, any})
  def serialise(%Comment{comment: some(comment)}) do
    comment
    |> String.split(~r/(\r\n|\r|\n)/)
    |> Enum.reject(&(byte_size(&1) == 0))
    |> Enum.map(&"(#{&1})")
    |> ok()
  end

  def serialise(%Comment{comment: none()}), do: {:error, {:serialise_error, :empty_comment}}
end
