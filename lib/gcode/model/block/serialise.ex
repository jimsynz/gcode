defimpl Gcode.Model.Serialise, for: Gcode.Model.Block do
  alias Gcode.{Model.Block, Model.Serialise, Result}
  use Gcode.Option
  use Gcode.Result

  @moduledoc """
  Implements the `Serialise` protocol for `Block`, meaning that blocks can be
  turned into G-code output.
  """

  @spec serialise(Block.t()) :: Result.t([String.t()], {:serialise_error, any})
  def serialise(%Block{words: words, comment: some(comment)}) do
    words
    |> encode_words()
    |> Result.map(fn words -> ok(["#{words} #{comment}"]) end)
  end

  def serialise(%Block{words: words, comment: none()}) do
    words
    |> encode_words()
    |> Result.map(fn words -> ok([words]) end)
  end

  defp encode_words(words) when is_list(words) do
    words
    |> Enum.reverse()
    |> ok()
    |> Result.Enum.map(&Serialise.serialise/1)
    |> Result.Enum.join(" ")
  end
end
