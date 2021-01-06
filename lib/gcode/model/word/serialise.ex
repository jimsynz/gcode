defimpl Gcode.Model.Serialise, for: Gcode.Model.Word do
  alias Gcode.Model.{Word, Serialise}
  use Gcode.Option
  use Gcode.Result

  @moduledoc """
  Implements the `Serialise` protocol for `Word`, allowing it to be turned into
  G-code output.
  """

  @spec serialise(Word.t()) :: Result.t([String.t()], {:serialise_error, any})
  def serialise(%Word{word: word, address: address})
      when is_binary(word) and byte_size(word) == 1 do
    with ok(address) <- Serialise.serialise(address),
         do: ok(["#{word}#{address}"])
  end

  def serialise(_word), do: error({:serialise_error, "invalid word"})
end
