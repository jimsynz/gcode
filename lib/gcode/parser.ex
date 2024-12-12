defmodule Gcode.Parser do
  use Gcode.Result
  alias Gcode.Model.{Block, Comment, Expr, Program, Word}
  alias Gcode.Parser.{Engine, Error}

  @moduledoc """
  A parser for G-code programs.

  This parser converts G-code input (in UTF-8 encoding) into representations
  with the contents of `Gcode.Model`.
  """

  @doc """
  Attempt to parse a G-code program from a string.
  """
  @spec parse_string(String.t()) :: Result.t(Program.t(), {:parse_error, String.t()})
  def parse_string(input) do
    with ok(tokens) <- Engine.parse(input),
         ok(program) <- hydrate(tokens) do
      ok(program)
    else
      error({message, unexpected, _, {line, _}, col}) ->
        error(
          {:parse_error,
           "Unexpected #{inspect(unexpected)} at line: #{line}:#{col + 1}. #{message}."}
        )

      error(reason) ->
        error({:parse_error, reason})
    end
  end

  @doc """
  Attempt to parse the G-code program at the given path.
  """
  @spec parse_file(Path.t()) :: Result.t(Program.t(), {:parse_error, String.t()})
  def parse_file(path) do
    with ok(input) <- File.read(path),
         ok(tokens) <- Engine.parse(input),
         ok(program) <- hydrate(tokens) do
      ok(program)
    else
      error({message, unexpected, _, {line, _}, col}) ->
        error(
          {:parse_error,
           "Unexpected #{inspect(unexpected)} at line: #{line}:#{col + 1}. #{message}."}
        )

      error(reason) ->
        error({:parse_error, reason})
    end
  end

  @doc """
  Parse and stream the G-code program from a string.

  Note that this function doesn't yield `Program` objects, but blocks, comments,
  etc.
  """
  @spec stream_string!(String.t()) :: Enumerable.t() | no_return
  def stream_string!(input) do
    input
    |> String.split(~r/\r?\n/)
    |> Stream.with_index()
    |> ParallelStream.map(&trim_line/1)
    |> ParallelStream.reject(&(elem(&1, 0) == ""))
    |> ParallelStream.map(&parse_line!/1)
  end

  @doc """
  Parse and stream the G-code program at the given location.

  Note that this function doesn't yield `Program` objects, but blocks, comments,
  etc.
  """
  @spec stream_file!(Path.t()) :: Enumerable.t() | no_return
  def stream_file!(path) do
    path
    |> File.stream!()
    |> Stream.with_index()
    |> ParallelStream.map(&trim_line/1)
    |> ParallelStream.reject(&(elem(&1, 0) == ""))
    |> ParallelStream.map(&parse_line!/1)
  end

  defp trim_line({input, line_no}), do: {String.trim(input), line_no}

  defp parse_line!({input, line_no}) do
    with ok(tokens) <- Engine.parse(input),
         ok(%Program{elements: [element]}) <- hydrate(tokens) do
      element
    else
      ok(%Program{elements: elements}) ->
        raise Error, "Expected line to result in 1 element, but contained #{length(elements)}"

      ok(%Block{}) ->
        raise Error, "Expected parser to return a program, but returned a block instead."

      error({:block_error, reason}) ->
        raise Error, "Block error #{reason}"

      error({:comment_error, reason}) ->
        raise Error, "Comment error #{reason}"

      error({:expression_error, reason}) ->
        raise Error, "Expression error #{reason}"

      error({:parse_error, reason}) ->
        raise Error, "Parse error: #{reason}"

      error({:program_error, reason}) ->
        raise Error, "Program error: #{reason}"

      error({:string_error, reason}) ->
        raise Error, "String error: #{reason}"

      error({:word_error, reason}) ->
        raise Error, "Word error: #{reason}"

      error({message, unexpected, _, _, col}) ->
        raise Error,
              "Unexpected #{inspect(unexpected)} at line: #{line_no + 1}:#{col + 1}. #{message}."
    end
  end

  defp hydrate(tokens) do
    with ok(program) <- Program.init(),
         do: hydrate(tokens, program)
  end

  defp hydrate([], result), do: ok(result)

  defp hydrate([{:comment, comment} | remaining], %Program{} = program) do
    with ok(comment) <- Comment.init(List.to_string(comment)),
         ok(program) <- Program.push(program, comment),
         do: hydrate(remaining, program)
  end

  defp hydrate([{:comment, comment} | remaining], %Block{} = block) do
    with ok(comment) <- Comment.init(List.to_string(comment)),
         ok(block) <- Block.comment(block, comment),
         do: hydrate(remaining, block)
  end

  defp hydrate([{:block, words} | remaining], %Program{} = program) do
    with ok(block) <- Block.init(),
         ok(block) <- hydrate(words, block),
         ok(program) <- Program.push(program, block),
         do: hydrate(remaining, program)
  end

  defp hydrate([{:word, contents} | remaining], %Block{} = block) do
    with ok(command) <- Keyword.fetch(contents, :command),
         ok(address) <- Keyword.fetch(contents, :address),
         ok(address) <- expression(address),
         ok(word) <- Word.init(List.to_string(command), address),
         ok(block) <- Block.push(block, word),
         do: hydrate(remaining, block)
  end

  defp hydrate([{:string, _} = str | remaining], %Block{} = block) do
    with ok(str) <- expression([str]),
         ok(block) <- Block.push(block, str),
         do: hydrate(remaining, block)
  end

  defp hydrate([{:newline, _} | remaining], %Program{} = program), do: hydrate(remaining, program)
  defp hydrate([{:newline, _}], %Block{} = block), do: ok(block)

  defp expression([{:-, inner}]) do
    with ok(inner) <- expression(inner),
         do: Expr.Unary.init(:-, inner)
  end

  defp expression([{:+, inner}]) do
    with ok(inner) <- expression(inner),
         do: Expr.Unary.init(:+, inner)
  end

  defp expression([{:!, inner}]) do
    with ok(inner) <- expression(inner),
         do: Expr.Unary.init(:!, inner)
  end

  defp expression([{:"#", inner}]) do
    with ok(inner) <- expression(inner),
         do: Expr.Unary.init(:"#", inner)
  end

  defp expression(integer: value) do
    value =
      value
      |> List.to_string()
      |> String.to_integer()

    Expr.Integer.init(value)
  end

  defp expression(float: value) do
    value =
      value
      |> List.to_string()
      |> String.to_float()

    Expr.Float.init(value)
  end

  defp expression(string: value) do
    value =
      value
      |> List.to_string()

    Expr.String.init(value)
  end
end
