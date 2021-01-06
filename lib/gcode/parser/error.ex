defmodule Gcode.Parser.Error do
  defexception message: nil

  @moduledoc """
  Parser's streaming outputs have no way to return a result type, so we are
  forced to rely on exceptions.  These are those exceptions.
  """
end
