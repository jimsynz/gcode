defmodule DescribeCase do
  use ExUnit.CaseTemplate
  alias Gcode.Model.{Block, Describe, Program, Word}
  use Gcode.Option
  use Gcode.Result
  @moduledoc false

  using do
    quote do
      use Gcode.Option
      use Gcode.Result
      import DescribeCase
    end
  end

  @regex ~r/^(?<word>[A-Z])(?<address>[+-]?(?<float>[0-9]+\.)?[0-9]+)$/

  def make_word(input) do
    case Regex.named_captures(@regex, input) do
      %{"word" => word, "address" => address, "float" => ""} ->
        Word.init(word, String.to_integer(address))

      %{"word" => word, "address" => address, "float" => _} ->
        Word.init(word, String.to_float(address))

      _ ->
        none()
    end
  end

  def make_block(input) do
    ok(block) = Block.init()

    input
    |> String.trim()
    |> String.split(~r/\s+/)
    |> Enum.map(&make_word/1)
    |> Enum.reject(&Option.none?/1)
    |> Enum.map(&Result.unwrap!/1)
    |> Result.Enum.reduce_while_ok(block, &Block.push(&2, &1))
  end

  @spec make_program(binary) :: Result.t()
  def make_program(input) do
    ok(program) = Program.init()

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&make_block/1)
    |> Enum.reject(&Option.none?/1)
    |> Enum.map(&Result.unwrap!/1)
    |> Result.Enum.reduce_while_ok(program, &Program.push(&2, &1))
  end

  defmacro describes_word(input, opts) when is_list(opts) do
    output = Keyword.fetch!(opts, :as)
    options = Keyword.get(opts, :with, [])

    description =
      if Enum.any?(options) do
        plural = if Enum.count(options) == 1, do: "option", else: "options"

        description =
          options
          |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)
          |> Enum.join(", ")

        "#{input} with #{plural} #{description}"
      else
        input
      end

    quote do
      describe unquote(description) do
        test "is described as #{inspect(unquote(output))}" do
          assert ok(word) = make_word(unquote(input))
          assert ok(description) = Describe.describe(word, unquote(options))
          assert description == unquote(output)
        end
      end
    end
  end

  defmacro describes_block(input, opts) when is_list(opts) do
    output = Keyword.fetch!(opts, :as)
    options = Keyword.get(opts, :with, [])

    description =
      if Enum.any?(options) do
        plural = if Enum.count(options) == 1, do: "option", else: "options"

        description =
          options
          |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)
          |> Enum.join(", ")

        "#{input} with #{plural} #{description}"
      else
        input
      end

    quote do
      describe unquote(description) do
        test "is described as #{inspect(unquote(output))}" do
          assert ok(block) = make_block(unquote(input))
          assert ok(description) = Describe.describe(block, unquote(options))
          assert description == unquote(output)
        end
      end
    end
  end

  defmacro describes_program(input, opts) do
    output = Keyword.fetch!(opts, :as)
    options = Keyword.get(opts, :with, [])

    description =
      if Enum.any?(options) do
        plural = if Enum.count(options) == 1, do: "option", else: "options"

        description =
          options
          |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)
          |> Enum.join(", ")

        "program with #{plural} #{description}"
      else
        "program"
      end

    quote do
      describe unquote(description) do
        test "is described correctly" do
          assert ok(program) = make_program(unquote(input))
          assert ok(description) = Describe.describe(program, unquote(options))
          assert description == unquote(output)
        end
      end
    end
  end
end
