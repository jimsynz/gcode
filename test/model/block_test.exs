defmodule Gcode.Model.BlockTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Block, Comment, Word}
  use Gcode.Option
  use Gcode.Result
  doctest Gcode.Model.Block
  @moduledoc false
end
