defmodule ParserEngineHelper do
  alias Gcode.Parser.Engine
  @moduledoc false

  defmacro __using__(_) do
    quote do
      require ParserEngineHelper
      import ParserEngineHelper
    end
  end

  defmacro it_parses_into(input, {:fn, _, _} = callback) do
    quote do
      input_length = byte_size(unquote(input))

      description =
        if input_length < 60,
          do: unquote(input),
          else: "#{input_length} byte input"

      test description do
        assert ok(tokens) = Engine.parse(unquote(input))
        unquote(callback).(tokens)
      end
    end
  end

  defmacro it_parses_into(input, pattern) do
    quote do
      input_length = byte_size(unquote(input))

      description =
        if input_length < 60,
          do: unquote(input),
          else: "#{input_length} byte input"

      test description do
        assert ok(tokens) = Engine.parse(unquote(input))
        assert unquote(pattern) = tokens
      end
    end
  end
end
