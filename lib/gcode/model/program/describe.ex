defimpl Gcode.Model.Describe, for: Gcode.Model.Program do
  alias Gcode.Model.{Describe, Program}
  use Gcode.Option

  @spec describe(Program.t(), options :: []) :: Option.t(String.t())
  def describe(%Program{elements: elements}, options) do
    lines =
      elements
      |> Enum.reverse()
      |> Enum.map(&Describe.describe(&1, options))
      |> Enum.reject(&(&1 == none()))
      |> Enum.map(fn some(line) -> "#{line}\n" end)
      |> Enum.join("")

    some(lines)
  end
end
