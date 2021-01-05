defimpl Gcode.Model.Serialise, for: Gcode.Model.Word do
  alias Gcode.Model.Word
  use Gcode.Option
  use Gcode.Result

  @spec serialise(Word.t()) :: Result.t([String.t()], {:serialise_error, any})
  def serialise(%Word{word: word, address: address}) when is_integer(address) do
    ok(["#{word}#{address}"])
  end

  def serialise(%Word{word: word, address: address}) when is_float(address) do
    ok(["#{word}#{address}"])
  end

  def serialise(_word), do: error({:serialise_error, "invalid word"})
end
