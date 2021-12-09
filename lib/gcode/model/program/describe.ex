defimpl Gcode.Model.Describe, for: Gcode.Model.Program do
  alias Gcode.Model.{Describe, Program}
  use Gcode.Option

  @moduledoc """
  Implements the `Describe` protocol for `Program`.
  """

  @spec describe(Program.t(), options :: []) :: Option.t(String.t())
  def describe(%Program{elements: elements}, options) do
    lines =
      elements
      |> Enum.reverse()
      |> Stream.map(&Describe.describe(&1, options))
      |> Stream.reject(&(&1 == none()))
      |> Stream.map(fn some(line) -> "#{line}\n" end)
      |> Enum.join("")

    some(lines)
  end
end
