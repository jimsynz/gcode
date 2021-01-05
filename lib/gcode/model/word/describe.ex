defimpl Gcode.Model.Describe, for: Gcode.Model.Word do
  use Gcode.Option
  use Gcode.Result
  alias Gcode.Model.Word

  @moduledoc """
  Describes common/conventional words.
  """

  @type options :: [option]
  @type option :: operation | positioning | compensation | units
  @type operation :: {:operation, :milling | :turning | :printing | :plotting}
  @type positioning :: {:positioning, :absolute | :relative}
  @type compensation :: {:compensation, :left | :right}
  @type units :: {:units, :mm | :inches}

  @doc "Refer `describe/2`"
  @spec describe(Word.t()) :: Option.t(String.t())
  def describe(word), do: do_describe(word, %{})

  @doc """
  Describe a word for human consumption.

  *Note:* Many words have different meanings depending on the operation, machine
  state or program state.  Use can use the `options` argument to provide a hint,
  otherwise a more-generic response will be shown.

  ## Examples

      iex> {:ok, word} = Word.init("N", 100)
      ...> Word.Describe.describe(word)
      {:ok, "Line/block number 100"}

      iex> {:ok, word} = Word.init("G", 0)
      ...> Word.Describe.describe(word)
      {:ok, "Rapid move"}

      iex> {:ok, word} = Word.init("A", 15)
      {:ok, "Rotate A axis counterclockwise by/to 15º"}

      iex> {:ok, word} = Word.init("A", -15, positioning: :absolute)
      {:ok, "Rotate A axis clockwise to 15º"}

      iex> {:ok, word} = Word.init("G", 8)
      :error
  """
  @spec describe(Word.t(), options) :: Option.t(String.t())
  def describe(%Word{} = word, options) when is_list(options),
    do: do_describe(word, Enum.into(options, %{}))

  defp do_describe(%Word{word: axis, address: angle}, %{positioning: :absolute})
       when axis in ~w[A B C] and angle >= 0,
       do: some("Rotate #{axis} axis counterclockwise to #{angle}º")

  defp do_describe(%Word{word: axis, address: angle}, %{positioning: :relative})
       when axis in ~w[A B C] and angle >= 0,
       do: some("Rotate #{axis} axis counterclockwise by #{angle}º")

  defp do_describe(%Word{word: axis, address: angle}, _)
       when axis in ~w[A B C] and angle >= 0,
       do: some("Rotate #{axis} axis counterclockwise by/to #{angle}º")

  defp do_describe(%Word{word: axis, address: angle}, %{positioning: :absolute})
       when axis in ~w[A B C] and angle < 0,
       do: some("Rotate #{axis} axis clockwise to #{abs(angle)}º")

  defp do_describe(%Word{word: axis, address: angle}, %{positioning: :relative})
       when axis in ~w[A B C] and angle < 0,
       do: some("Rotate #{axis} axis clockwise by #{abs(angle)}º")

  defp do_describe(%Word{word: axis, address: angle}, _)
       when axis in ~w[A B C] and angle < 0,
       do: some("Rotate #{axis} axis clockwise by/to #{abs(angle)}º")

  defp do_describe(%Word{word: "D", address: depth}, %{operation: :turning} = options),
    do: some("Depth of cut #{distance_with_unit(depth, options)}")

  defp do_describe(%Word{word: "D", address: aperture}, %{operation: :plotting}),
    do: some("Aperture #{aperture}")

  defp do_describe(%Word{word: "D", address: offset}, %{compensation: :left} = options),
    do: some("Left radial offset #{distance_with_unit(offset, options)}")

  defp do_describe(%Word{word: "D", address: offset}, %{compensation: :right} = options),
    do: some("Right radial offset #{distance_with_unit(offset, options)}")

  defp do_describe(%Word{word: "D", address: offset}, options),
    do: some("Radial offset #{distance_with_unit(offset, options)}")

  defp do_describe(%Word{word: "E", address: feedrate}, %{operation: :printing} = options),
    do: some("Extruder feedrate #{feedrate(feedrate, options)}")

  defp do_describe(%Word{word: "E", address: feedrate}, %{operation: :turning} = options),
    do: some("Precision feedrate #{feedrate(feedrate, options)}")

  defp do_describe(%Word{word: "F", address: feedrate}, options),
    do: some("Feedrate #{feedrate(feedrate, options)}")

  defp do_describe(%Word{word: "G", address: 0}, _), do: some("Rapid move")
  defp do_describe(%Word{word: "G", address: 1}, _), do: some("Linear move")
  defp do_describe(%Word{word: "G", address: 2}, _), do: some("Clockwise circular move")
  defp do_describe(%Word{word: "G", address: 3}, _), do: some("Counterclockwise circular move")
  defp do_describe(%Word{word: "G", address: 4}, _), do: some("Dwell")
  defp do_describe(%Word{word: "G", address: 5}, _), do: some("High-precision contour control")
  defp do_describe(%Word{word: "G", address: 5.1}, _), do: some("AI advanced preview control")
  defp do_describe(%Word{word: "G", address: 6.1}, _), do: some("NURBS machining")
  defp do_describe(%Word{word: "G", address: 7}, _), do: some("Imaginary axis designation")
  defp do_describe(%Word{word: "G", address: 9}, _), do: some("Exact stop check - non-modal")
  defp do_describe(%Word{word: "G", address: 10}, _), do: some("Programmable data input")
  defp do_describe(%Word{word: "G", address: 11}, _), do: some("Data write cancel")
  defp do_describe(%Word{word: "G", address: 17}, _), do: some("XY plane selection")
  defp do_describe(%Word{word: "G", address: 18}, _), do: some("ZX plane selection")
  defp do_describe(%Word{word: "G", address: 19}, _), do: some("YZ plane selection")
  defp do_describe(%Word{word: "G", address: 20}, _), do: some("Unit is inches")
  defp do_describe(%Word{word: "G", address: 21}, _), do: some("Unit is mm")
  defp do_describe(%Word{word: "G", address: 28}, _), do: some("Return to home position")

  defp do_describe(%Word{word: "G", address: 30}, _),
    do: some("Return to secondary home position")

  defp do_describe(%Word{word: "G", address: 31}, _), do: some("Feed until skip function")
  defp do_describe(%Word{word: "G", address: 32}, _), do: some("Single-point threading")
  defp do_describe(%Word{word: "G", address: 33}, _), do: some("Variable pitch threading")
  defp do_describe(%Word{word: "G", address: 40}, _), do: some("Tool radius compensation off")
  defp do_describe(%Word{word: "G", address: 41}, _), do: some("Tool radius compensation left")
  defp do_describe(%Word{word: "G", address: 42}, _), do: some("Tool radius compensation right")

  defp do_describe(%Word{word: "G", address: 43}, _),
    do: some("Tool height offset compensation negative")

  defp do_describe(%Word{word: "G", address: 44}, _),
    do: some("Tool height offset compensation positive")

  defp do_describe(%Word{word: "G", address: 45}, _), do: some("Axis offset single increase")
  defp do_describe(%Word{word: "G", address: 46}, _), do: some("Axis offset single decrease")
  defp do_describe(%Word{word: "G", address: 47}, _), do: some("Axis offset double increase")
  defp do_describe(%Word{word: "G", address: 48}, _), do: some("Axis offset double decrease")

  defp do_describe(%Word{word: "G", address: 49}, _),
    do: some("Tool length offset compensation cancel")

  defp do_describe(%Word{word: "G", address: 50}, %{operation: :turning}),
    do: some("Position register")

  defp do_describe(%Word{word: "G", address: 50}, _), do: some("Scaling function cancel")
  defp do_describe(%Word{word: "G", address: 52}, _), do: some("Local coordinate system")
  defp do_describe(%Word{word: "G", address: 53}, _), do: some("Machine coordinate system")

  defp do_describe(%Word{word: "G", address: address}, _)
       when address in [54, 55, 56, 57, 58, 59, 54.1],
       do: some("Work coordinate system")

  defp do_describe(%Word{word: "G", address: 61}, _), do: some("Exact stop check - modal")
  defp do_describe(%Word{word: "G", address: 62}, _), do: some("Automatic corner override")
  defp do_describe(%Word{word: "G", address: 64}, _), do: some("Default cutting mode")
  defp do_describe(%Word{word: "G", address: 68}, _), do: some("Rotate coordinate system")

  defp do_describe(%Word{word: "G", address: 69}, _),
    do: some("Turn off coordinate system rotation")

  defp do_describe(%Word{word: "G", address: 70}, %{operation: :turning}),
    do: some("Fixed cycle, multiple repetitive cycle - for finishing")

  defp do_describe(%Word{word: "G", address: 71}, %{operation: :turning}),
    do: some("Fixed cycle, multiple repetitive cycle - for roughing with Z axis emphasis")

  defp do_describe(%Word{word: "G", address: 72}, %{operation: :turning}),
    do: some("Fixed cycle, multiple repetitive cycle - for roughing with X axis emphasis")

  defp do_describe(%Word{word: "G", address: 73}, %{operation: :turning}),
    do: some("Fixed cycle, multiple repetitive cycle - for roughing with pattern repetition")

  defp do_describe(%Word{word: "G", address: 73}, _), do: some("Peck drilling cycle")

  defp do_describe(%Word{word: "G", address: 74}, %{operation: :turning}),
    do: some("Peck drilling cycle")

  defp do_describe(%Word{word: "G", address: 74}, _), do: some("Tapping cycle")

  defp do_describe(%Word{word: "G", address: 75}, %{operation: :turning}),
    do: some("Peck grooving cycle")

  defp do_describe(%Word{word: "G", address: 76}, %{operation: :turning}),
    do: some("Threading cycle")

  defp do_describe(%Word{word: "G", address: 76}, _), do: some("Fine boring cycle")
  defp do_describe(%Word{word: "G", address: 80}, _), do: some("Cancel cycle")
  defp do_describe(%Word{word: "G", address: 81}, _), do: some("Simple drilling cycle")
  defp do_describe(%Word{word: "G", address: 82}, _), do: some("Drilling cycle with dwell")
  defp do_describe(%Word{word: "G", address: 83}, _), do: some("Peck drilling cycle")

  defp do_describe(%Word{word: "G", address: 84}, _),
    do: some("Tapping cycle, righthand thread, M03 spindle direction")

  defp do_describe(%Word{word: "G", address: 84.2}, _),
    do: some("Tapping cycle, righthand thread, M03 spindle direction, rigid toolholder")

  defp do_describe(%Word{word: "G", address: 84.3}, _),
    do: some("Tapping cycle, lefthand thread, M04 spindle direction, rigid toolholder")

  defp do_describe(%Word{word: "G", address: 85}, _), do: some("Boring cycle, feed in/feed out")

  defp do_describe(%Word{word: "G", address: 86}, _),
    do: some("Boring cycle, feed in/spindle stop/rapid out")

  defp do_describe(%Word{word: "G", address: 87}, _), do: some("Boring cycle, backboring")

  defp do_describe(%Word{word: "G", address: 88}, _),
    do: some("Boring cycle, feed in/spindle stop/manual operation")

  defp do_describe(%Word{word: "G", address: 89}, _),
    do: some("Boring cycle, feed in/dwell/feed out")

  defp do_describe(%Word{word: "G", address: 90}, _), do: some("Absolute positioning")
  defp do_describe(%Word{word: "G", address: 91}, _), do: some("Relative positioning")
  defp do_describe(%Word{word: "G", address: 92}, _), do: some("Position register")
  defp do_describe(%Word{word: "G", address: 94}, _), do: some("Feedrate per minute")
  defp do_describe(%Word{word: "G", address: 95}, _), do: some("Feedrate per revolution")
  defp do_describe(%Word{word: "G", address: 96}, _), do: some("Constant surface speed")
  defp do_describe(%Word{word: "G", address: 97}, _), do: some("Constant spindle speed")

  defp do_describe(%Word{word: "G", address: 98}, %{operation: :turning}),
    do: some("Feedrate per minute")

  defp do_describe(%Word{word: "G", address: 98}, _),
    do: some("Return to initial Z level in canned cycle")

  defp do_describe(%Word{word: "G", address: 99}, %{operation: :turning}),
    do: some("Feedrate per revolution")

  defp do_describe(%Word{word: "G", address: 99}, _),
    do: some("Return to R level in canned cycle")

  defp do_describe(%Word{word: "G", address: 100}, _), do: some("Tool length measurement")

  defp do_describe(%Word{word: "H", address: length}, options),
    do: some("Tool length offset #{distance_with_unit(length, options)}")

  defp do_describe(%Word{word: "I", address: offset}, options),
    do: some("X arc center offset #{distance_with_unit(offset, options)}")

  defp do_describe(%Word{word: "J", address: offset}, options),
    do: some("Y arc center offset #{distance_with_unit(offset, options)}")

  defp do_describe(%Word{word: "K", address: offset}, options),
    do: some("Z arc center offset #{distance_with_unit(offset, options)}")

  defp do_describe(%Word{word: "L", address: count}, _), do: some("Loop count #{count}")

  defp do_describe(%Word{word: "M", address: 0}, _), do: some("Compulsory stop")
  defp do_describe(%Word{word: "M", address: 1}, _), do: some("Optional stop")
  defp do_describe(%Word{word: "M", address: 2}, _), do: some("End of program")
  defp do_describe(%Word{word: "M", address: 3}, _), do: some("Spindle on clockwise")
  defp do_describe(%Word{word: "M", address: 4}, _), do: some("Spindle on counterclockwise")
  defp do_describe(%Word{word: "M", address: 5}, _), do: some("Spindle stop")
  defp do_describe(%Word{word: "M", address: 6}, _), do: some("Automatic tool change")
  defp do_describe(%Word{word: "M", address: 7}, _), do: some("Coolant mist")
  defp do_describe(%Word{word: "M", address: 8}, _), do: some("Coolant flood")
  defp do_describe(%Word{word: "M", address: 9}, _), do: some("Coolant off")
  defp do_describe(%Word{word: "M", address: 10}, _), do: some("Pallet clamp on")
  defp do_describe(%Word{word: "M", address: 11}, _), do: some("Pallet clamp off")

  defp do_describe(%Word{word: "M", address: 13}, _),
    do: some("Spindle on clockwise and coolant flood")

  defp do_describe(%Word{word: "M", address: 19}, _), do: some("Spindle orientation")

  defp do_describe(%Word{word: "M", address: 21}, %{operation: :turning}),
    do: some("Tailstock forward")

  defp do_describe(%Word{word: "M", address: 21}, _), do: some("Mirror X axis")

  defp do_describe(%Word{word: "M", address: 22}, %{operation: :turning}),
    do: some("Tailstock backward")

  defp do_describe(%Word{word: "M", address: 22}, _), do: some("Mirror Y axis")

  defp do_describe(%Word{word: "M", address: 23}, %{operation: :turning}),
    do: some("Thread gradual pullout on")

  defp do_describe(%Word{word: "M", address: 23}, _), do: some("Mirror off")

  defp do_describe(%Word{word: "M", address: 24}, %{operation: :turning}),
    do: some("Thread gradual pullout off")

  defp do_describe(%Word{word: "M", address: 30}, _), do: some("End of program")

  defp do_describe(%Word{word: "M", address: gear}, %{operation: :turning})
       when is_integer(gear) and gear > 40 and gear < 45,
       do: some("Gear select #{gear - 40}")

  defp do_describe(%Word{word: "M", address: 48}, _), do: some("Feedrate override allowed")
  defp do_describe(%Word{word: "M", address: 49}, _), do: some("Feedrate override not allowed")
  defp do_describe(%Word{word: "M", address: 52}, _), do: some("Unload tool")
  defp do_describe(%Word{word: "M", address: 60}, _), do: some("Automatic pallet change")
  defp do_describe(%Word{word: "M", address: 98}, _), do: some("Subprogram call")
  defp do_describe(%Word{word: "M", address: 99}, _), do: some("Subprogram end")
  defp do_describe(%Word{word: "M", address: 100}, _), do: some("Clean nozzle")
  defp do_describe(%Word{word: "N", address: line}, _), do: some("Line #{line}")
  defp do_describe(%Word{word: "O", address: name}, _), do: some("Program #{name}")
  defp do_describe(%Word{word: "P", address: param}, _), do: some("Parameter #{param}")

  defp do_describe(%Word{word: "Q", address: distance}, options),
    do: some("Peck increment #{distance_with_unit(distance, options)}")

  defp do_describe(%Word{word: "R", address: distance}, options),
    do: some("Radius #{distance_with_unit(distance, options)}")

  defp do_describe(%Word{word: "S", address: speed}, _), do: some("Speed #{speed}")
  defp do_describe(%Word{word: "T", address: tool}, _), do: some("Tool #{tool}")

  defp do_describe(%Word{word: "X", address: position}, options),
    do: some("X #{distance_with_unit(position, options)}")

  defp do_describe(%Word{word: "Y", address: position}, options),
    do: some("Y #{distance_with_unit(position, options)}")

  defp do_describe(%Word{word: "Z", address: position}, options),
    do: some("Z #{distance_with_unit(position, options)}")

  defp do_describe(%Word{}, _options), do: none()

  defp distance_with_unit(distance, %{units: :mm}), do: "#{distance}mm"
  defp distance_with_unit(distance, %{units: :inches}), do: "#{distance}\""
  defp distance_with_unit(distance, _), do: distance

  defp feedrate(distance, %{operation: :turning} = options),
    do: "#{distance_with_unit(distance, options)}/rev"

  defp feedrate(distance, options), do: "#{distance_with_unit(distance, options)}/min"
end
