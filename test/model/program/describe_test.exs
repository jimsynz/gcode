defmodule Gcode.Model.Program.DescribeTest do
  use DescribeCase, async: true
  @moduledoc false

  @program """
  O4968
  N01 M216
  N02 G20 G90 G54 D200 G40
  N03 G50 S2000
  N04 T0300
  N05 G96 S854 M03
  N06 G41 G00 X1.1 Z1.1 T0303 M08
  N07 G01 Z1.0 F.05
  N08 X-0.016
  N09 G00 Z1.1
  N10 X1.0
  N11 G01 Z0.0 F.05
  N12 G00 X1.1 M05 M09
  N13 G91 G28 X0
  N14 G91 G28 Z0
  N15 G90
  N16 M30
  """

  @expected """
  Program 4968
  Line 1, M216
  Line 2, Unit is inches, Absolute positioning, Work coordinate system, Radial offset 200, Tool radius compensation off
  Line 3, Scaling function cancel, Speed 2000
  Line 4, Tool 300
  Line 5, Constant surface speed, Speed 854, Spindle on clockwise
  Line 6, Tool radius compensation left, Rapid move, X 1.1, Z 1.1, Tool 303, Coolant flood
  Line 7, Linear move, Z 1.0
  Line 8, X -0.016
  Line 9, Rapid move, Z 1.1
  Line 10, X 1.0
  Line 11, Linear move, Z 0.0
  Line 12, Rapid move, X 1.1, Spindle stop, Coolant off
  Line 13, Relative positioning, Return to home position, X 0
  Line 14, Relative positioning, Return to home position, Z 0
  Line 15, Absolute positioning
  Line 16, End of program
  """

  describes_program(@program, as: @expected)
end
