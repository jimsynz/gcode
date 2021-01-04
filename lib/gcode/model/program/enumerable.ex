defimpl Enumerable, for: Gcode.Model.Program do
  alias Gcode.Model.Program
  @moduledoc false

  @spec count(Program.t()) :: {:ok, non_neg_integer()} | {:error, module}
  def count(%Program{elements: elements}), do: {:ok, Enum.count(elements)}

  @spec member?(Program.t(), any) :: {:error, module} | {:ok, boolean}
  def member?(%Program{elements: elements}, element), do: Enumerable.member?(elements, element)

  @spec reduce(Program.t(), Enumerable.acc(), Enumerable.reducer()) :: Enumerable.result()
  def reduce(%Program{elements: elements}, acc, fun), do: Enumerable.reduce(elements, acc, fun)

  @spec slice(Program.t()) ::
          {:ok, non_neg_integer, Enumerable.slicing_fun()} | {:error, module}
  def slice(%Program{elements: elements}), do: Enumerable.slice(elements)
end
