defimpl Inspect, for: Gcode.Model.Word do
  alias Gcode.Model.{Describe, Expr, Word}
  use Gcode.Option
  use Gcode.Result
  import Inspect.Algebra
  @moduledoc false

  def inspect(%Word{word: letter, address: address} = word, opts) do
    address =
      case Expr.evaluate(address) do
        ok(address) -> address
        error(reason) -> "Address error: #{inspect(reason)}"
      end

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
