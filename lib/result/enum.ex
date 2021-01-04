defmodule Gcode.Result.Enum do
  @moduledoc false
  use Gcode.Result

  @type result :: Result.t()
  @type result(result) :: Result.t(result)
  @type result(result, error) :: Result.t(result, error)

  @doc "As long as the result of the reducer is ok, continue reducing, otherwise short circuit"
  @spec reduce_while_ok(
          enumerable :: any,
          accumulator :: any,
          reducer :: (any, any -> result(any))
        ) :: result(any)
  def reduce_while_ok(elements, acc, reducer) when is_function(reducer, 2) do
    Enum.reduce_while(elements, {:ok, acc}, fn element, {:ok, acc} ->
      case reducer.(element, acc) do
        {:ok, acc} -> {:cont, {:ok, acc}}
        {:error, reason} -> {:halt, {:error, reason}}
      end
    end)
  end

  @spec map(result([any]), mapper :: (any -> result(any))) :: result([any])
  def map({:ok, enumerable}, mapper) when is_function(mapper, 1) do
    reduce_while_ok(enumerable, [], fn element, acc ->
      case mapper.(element) do
        {:ok, mapped} -> {:ok, [mapped | acc]}
        {:error, reason} -> {:error, reason}
      end
    end)
    |> reverse()
  end

  def map({:error, reason}, _mapper), do: {:error, reason}

  @spec reverse(result([any])) :: result([any])
  def reverse({:ok, enumerable}), do: {:ok, Enum.reverse(enumerable)}
  def reverse({:error, reason}), do: {:error, reason}

  @spec join(result([String.t()]), String.t()) :: result(String.t())
  def join({:ok, strings}, joiner) when is_binary(joiner), do: {:ok, Enum.join(strings, joiner)}
  def join({:error, reason}, _joiner), do: {:error, reason}
end
