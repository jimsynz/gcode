defimpl Inspect, for: Gcode.Model.Word do
  alias Gcode.Model.{Describe, Word}
  use Gcode.Option
  import Inspect.Algebra
  @moduledoc false

  def inspect(%Word{word: letter, address: address} = word, opts) do
    case Describe.describe(word) do
      some(description) ->
        concat([
          "#Gcode.Word<",
          to_doc([word: letter, address: address], opts),
          " (#{description})>"
        ])

      none() ->
        concat(["#Gcode.Word<", to_doc([word: letter, address: address], opts), ">"])
    end
  end
end
