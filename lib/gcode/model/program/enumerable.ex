defimpl Enumerable, for: Gcode.Model.Program do
  alias Gcode.Model.Program
  use Gcode.Result

  @moduledoc """
  Implements the `Enumerable` protocol for `Program`.
  """

  @spec count(Program.t()) :: Result.t(non_neg_integer, module)
  def count(%Program{elements: elements}),
    do: {:ok, Enum.count(elements)}

  @spec member?(Program.t(), any) :: Result.t(boolean, module)
  def member?(%Program{elements: elements}, element),
    do: Enumerable.member?(elements, element)

  @spec reduce(Program.t(), Enumerable.acc(), Enumerable.reducer()) :: Enumerable.result()
  def reduce(%Program{elements: elements}, acc, fun),
    do: Enumerable.reduce(elements, acc, fun)

  @spec slice(Program.t()) ::
          {:ok, non_neg_integer, Enumerable.slicing_fun()} | Result.error(module)
  def slice(%Program{elements: elements}), do: Enumerable.slice(elements)
end
