defmodule Gcode.Model.Word.DescribeTest do
  use DescribeCase, async: true
  @moduledoc false

  describes_word("A13", as: "Rotate A axis counterclockwise by/to 13º")
  describes_word("B-15.2", with: [positioning: :absolute], as: "Rotate B axis clockwise to 15.2º")

  describes_word("C99",
    with: [positioning: :relative],
    as: "Rotate C axis counterclockwise by 99º"
  )

  describes_word("D22", as: "Radial offset 22")
  describes_word("D22", with: [operation: :turning], as: "Depth of cut 22")
  describes_word("D22", with: [operation: :plotting], as: "Aperture 22")
  describes_word("D22", with: [compensation: :left, units: :mm], as: "Left radial offset 22mm")

  describes_word("D22",
    with: [compensation: :right, units: :inches],
    as: "Right radial offset 22\""
  )

  describes_word("E123",
    with: [operation: :turning, units: :mm],
    as: "Precision feedrate 123mm/rev"
  )

  describes_word("E123",
    with: [operation: :printing, units: :inches],
    as: "Extruder feedrate 123\"/min"
  )

  describes_word("E123", with: [operation: :turning], as: "Precision feedrate 123/rev")
  describes_word("F100", with: [operation: :turning, units: :mm], as: "Feedrate 100mm/rev")
  describes_word("F100", with: [units: :inches], as: "Feedrate 100\"/min")
  describes_word("F100", as: "Feedrate 100/min")

  describes_word("G0", as: "Rapid move")
  describes_word("G1", as: "Linear move")
  describes_word("G2", as: "Clockwise circular move")
  describes_word("G3", as: "Counterclockwise circular move")
  describes_word("G4", as: "Dwell")
  describes_word("G5", as: "High-precision contour control")
  describes_word("G5.1", as: "AI advanced preview control")
  describes_word("G6.1", as: "NURBS machining")
  describes_word("G7", as: "Imaginary axis designation")
  describes_word("G9", as: "Exact stop check - non-modal")
  describes_word("G10", as: "Programmable data input")
  describes_word("G11", as: "Data write cancel")
  describes_word("G17", as: "XY plane selection")
  describes_word("G18", as: "ZX plane selection")
  describes_word("G19", as: "YZ plane selection")
  describes_word("G20", as: "Unit is inches")
  describes_word("G21", as: "Unit is mm")
  describes_word("G28", as: "Return to home position")
  describes_word("G30", as: "Return to secondary home position")
  describes_word("G31", as: "Feed until skip function")
  describes_word("G32", as: "Single-point threading")
  describes_word("G33", as: "Variable pitch threading")
  describes_word("G40", as: "Tool radius compensation off")
  describes_word("G41", as: "Tool radius compensation left")
  describes_word("G42", as: "Tool radius compensation right")
  describes_word("G43", as: "Tool height offset compensation negative")
  describes_word("G44", as: "Tool height offset compensation positive")
  describes_word("G45", as: "Axis offset single increase")
  describes_word("G46", as: "Axis offset single decrease")
  describes_word("G47", as: "Axis offset double increase")
  describes_word("G48", as: "Axis offset double decrease")
  describes_word("G49", as: "Tool length offset compensation cancel")
  describes_word("G50", as: "Scaling function cancel")
  describes_word("G50", with: [operation: :turning], as: "Position register")
  describes_word("G52", as: "Local coordinate system")
  describes_word("G53", as: "Machine coordinate system")
  describes_word("G54", as: "Work coordinate system")
  describes_word("G55", as: "Work coordinate system")
  describes_word("G56", as: "Work coordinate system")
  describes_word("G57", as: "Work coordinate system")
  describes_word("G58", as: "Work coordinate system")
  describes_word("G59", as: "Work coordinate system")
  describes_word("G54.1", as: "Work coordinate system")
  describes_word("G61", as: "Exact stop check - modal")
  describes_word("G62", as: "Automatic corner override")
  describes_word("G64", as: "Default cutting mode")
  describes_word("G68", as: "Rotate coordinate system")
  describes_word("G69", as: "Turn off coordinate system rotation")

  describes_word("G70",
    with: [operation: :turning],
    as: "Fixed cycle, multiple repetitive cycle - for finishing"
  )

  describes_word("G71",
    with: [operation: :turning],
    as: "Fixed cycle, multiple repetitive cycle - for roughing with Z axis emphasis"
  )

  describes_word("G72",
    with: [operation: :turning],
    as: "Fixed cycle, multiple repetitive cycle - for roughing with X axis emphasis"
  )

  describes_word("G73",
    with: [operation: :turning],
    as: "Fixed cycle, multiple repetitive cycle - for roughing with pattern repetition"
  )

  describes_word("G73", as: "Peck drilling cycle")
  describes_word("G74", with: [operation: :turning], as: "Peck drilling cycle")
  describes_word("G74", as: "Tapping cycle")
  describes_word("G75", with: [operation: :turning], as: "Peck grooving cycle")
  describes_word("G76", as: "Fine boring cycle")
  describes_word("G76", with: [operation: :turning], as: "Threading cycle")
  describes_word("G80", as: "Cancel cycle")
  describes_word("G81", as: "Simple drilling cycle")
  describes_word("G82", as: "Drilling cycle with dwell")
  describes_word("G83", as: "Peck drilling cycle")
  describes_word("G84", as: "Tapping cycle, righthand thread, M03 spindle direction")

  describes_word("G84.2",
    as: "Tapping cycle, righthand thread, M03 spindle direction, rigid toolholder"
  )

  describes_word("G84.3",
    as: "Tapping cycle, lefthand thread, M04 spindle direction, rigid toolholder"
  )

  describes_word("G85", as: "Boring cycle, feed in/feed out")
  describes_word("G86", as: "Boring cycle, feed in/spindle stop/rapid out")
  describes_word("G87", as: "Boring cycle, backboring")
  describes_word("G88", as: "Boring cycle, feed in/spindle stop/manual operation")
  describes_word("G89", as: "Boring cycle, feed in/dwell/feed out")
  describes_word("G90", as: "Absolute positioning")
  describes_word("G91", as: "Relative positioning")
  describes_word("G92", as: "Position register")
  describes_word("G94", as: "Feedrate per minute")
  describes_word("G95", as: "Feedrate per revolution")
  describes_word("G96", as: "Constant surface speed")
  describes_word("G97", as: "Constant spindle speed")
  describes_word("G98", as: "Return to initial Z level in canned cycle")
  describes_word("G98", with: [operation: :turning], as: "Feedrate per minute")
  describes_word("G99", as: "Return to R level in canned cycle")
  describes_word("G99", with: [operation: :turning], as: "Feedrate per revolution")
  describes_word("G100", as: "Tool length measurement")
  describes_word("H76", with: [units: :mm], as: "Tool length offset 76mm")
  describes_word("I1.21", with: [units: :mm], as: "X arc center offset 1.21mm")
  describes_word("J1.21", with: [units: :inches], as: "Y arc center offset 1.21\"")
  describes_word("K1.21", as: "Z arc center offset 1.21")
  describes_word("L87", as: "Loop count 87")
  describes_word("M0", as: "Compulsory stop")
  describes_word("M1", as: "Optional stop")
  describes_word("M2", as: "End of program")
  describes_word("M3", as: "Spindle on clockwise")
  describes_word("M4", as: "Spindle on counterclockwise")
  describes_word("M5", as: "Spindle stop")
  describes_word("M6", as: "Automatic tool change")
  describes_word("M7", as: "Coolant mist")
  describes_word("M8", as: "Coolant flood")
  describes_word("M9", as: "Coolant off")
  describes_word("M10", as: "Pallet clamp on")
  describes_word("M11", as: "Pallet clamp off")
  describes_word("M13", as: "Spindle on clockwise and coolant flood")
  describes_word("M19", as: "Spindle orientation")
  describes_word("M21", as: "Mirror X axis")
  describes_word("M21", with: [operation: :turning], as: "Tailstock forward")
  describes_word("M22", as: "Mirror Y axis")
  describes_word("M22", with: [operation: :turning], as: "Tailstock backward")
  describes_word("M23", as: "Mirror off")
  describes_word("M23", with: [operation: :turning], as: "Thread gradual pullout on")
  describes_word("M24", with: [operation: :turning], as: "Thread gradual pullout off")
  describes_word("M30", as: "End of program")
  describes_word("M41", with: [operation: :turning], as: "Gear select 1")
  describes_word("M42", with: [operation: :turning], as: "Gear select 2")
  describes_word("M43", with: [operation: :turning], as: "Gear select 3")
  describes_word("M44", with: [operation: :turning], as: "Gear select 4")
  describes_word("M48", as: "Feedrate override allowed")
  describes_word("M49", as: "Feedrate override not allowed")
  describes_word("M52", as: "Unload tool")
  describes_word("M60", as: "Automatic pallet change")
  describes_word("M98", as: "Subprogram call")
  describes_word("M99", as: "Subprogram end")
  describes_word("M100", as: "Clean nozzle")
  describes_word("N100", as: "Line 100")
  describes_word("O200", as: "Program 200")
  describes_word("P12", as: "Parameter 12")
  describes_word("Q34", as: "Peck increment 34")
  describes_word("R37", with: [units: :mm], as: "Radius 37mm")
  describes_word("S12", as: "Speed 12")
  describes_word("T4", as: "Tool 4")
  describes_word("X2.34", as: "X 2.34")
  describes_word("Y3.45", as: "Y 3.45")
  describes_word("Z4.56", as: "Z 4.56")
end
