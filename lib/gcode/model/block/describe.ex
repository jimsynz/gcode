defimpl Gcode.Model.Describe, for: Gcode.Model.Block do
  alias Gcode.Model.{Block, Describe, Serialise}
  use Gcode.Option
  use Gcode.Result

  @moduledoc """
  Implements the `Describe` protocol for `Block`, meaning that we can convert
  blocks into human-readable strings.
  """

  @doc false
  @spec describe(Block.t(), options :: []) :: Option.t(String.t())
  def describe(%Block{words: words, comment: some(comment)}, options) do
    words = describe_words(words, options)
    some("#{words} (#{comment.comment})")
  end

  def describe(%Block{words: words}, options) do
    words = describe_words(words, options)
    some(words)
  end

  defp describe_words(words, options) do
    words
    |> Enum.reverse()
    |> Stream.map(&describe_or_serialise(&1, options))
    |> Stream.reject(&Option.none?/1)
    |> Stream.map(&Option.unwrap!/1)
    |> Enum.join(", ")
  end

  defp describe_or_serialise(word, options) do
    case Describe.describe(word, options) do
      some(description) ->
        some(description)

      none() ->
        case Serialise.serialise(word) do
          ok(serialised) ->
            serialised
            |> Enum.join(", ")
            |> some()

          error(_) ->
            none()
        end
    end
  end
end
