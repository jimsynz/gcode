defmodule Gcode.Model.Block.DescribeTest do
  use DescribeCase, async: true
  @moduledoc false

  describes_block("A13 B-15.2",
    with: [positioning: :absolute],
    as: "Rotate A axis counterclockwise to 13º, Rotate B axis clockwise to 15.2º"
  )

  describes_block("G90 M213", as: "Absolute positioning, M213")
end
