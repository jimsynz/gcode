defimpl Gcode.Model.Describe, for: Gcode.Model.Word do
  import Gcode.Model.Expr.Helpers
  use Gcode.Option
  use Gcode.Result
  alias Gcode.Model.{Expr, Word}

  # credo:disable-for-this-file Credo.Check.Refactor.CyclomaticComplexity

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
       when axis in ~w[A B C] do
    case Expr.evaluate(angle) do
      ok(angle) when is_number(angle) and angle >= 0 ->
        some("Rotate #{axis} axis counterclockwise to #{angle}º")

      ok(angle) when is_number(angle) and angle < 0 ->
        some("Rotate #{axis} axis clockwise to #{abs(angle)}º")

      error(_) ->
        none()
    end
  end

  defp do_describe(%Word{word: axis, address: angle}, %{positioning: :relative})
       when axis in ~w[A B C] do
    case Expr.evaluate(angle) do
      ok(angle) when is_number(angle) and angle >= 0 ->
        some("Rotate #{axis} axis counterclockwise by #{angle}º")

      ok(angle) when is_number(angle) and angle < 0 ->
        some("Rotate #{axis} axis clockwise by #{abs(angle)}º")

      error(_) ->
        none()
    end
  end

  defp do_describe(%Word{word: axis, address: angle}, _)
       when axis in ~w[A B C] do
    case Expr.evaluate(angle) do
      ok(angle) when is_number(angle) and angle >= 0 ->
        some("Rotate #{axis} axis counterclockwise by/to #{angle}º")

      ok(angle) when is_number(angle) and angle < 0 ->
        some("Rotate #{axis} axis clockwise by/to #{abs(angle)}º")

      error(_) ->
        none()
    end
  end

  defp do_describe(%Word{word: "D", address: depth}, %{operation: :turning} = options) do
    case distance_with_unit(depth, options) do
      some(depth) ->
        some("Depth of cut #{depth}")

      _ ->
        none()
    end
  end

  defp do_describe(%Word{word: "D", address: aperture}, %{operation: :plotting}) do
    case Expr.evaluate(aperture) do
      some(aperture) when is_number(aperture) -> some("Aperture #{aperture}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "D", address: offset}, %{compensation: :left} = options) do
    case distance_with_unit(offset, options) do
      some(offset) -> some("Left radial offset #{offset}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "D", address: offset}, %{compensation: :right} = options) do
    case distance_with_unit(offset, options) do
      some(offset) -> some("Right radial offset #{offset}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "D", address: offset}, options) do
    case distance_with_unit(offset, options) do
      some(offset) -> some("Radial offset #{offset}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "E", address: feedrate}, %{operation: :printing} = options) do
    case feedrate(feedrate, options) do
      some(feedrate) -> some("Extruder feedrate #{feedrate}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "E", address: feedrate}, %{operation: :turning} = options) do
    case feedrate(feedrate, options) do
      some(feedrate) -> some("Precision feedrate #{feedrate}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "F", address: feedrate}, options) do
    case feedrate(feedrate, options) do
      some(feedrate) -> some("Feedrate #{feedrate}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "G", address: address}, options) do
    case {Expr.evaluate(address), options} do
      {ok(0), _} ->
        some("Rapid move")

      {ok(1), _} ->
        some("Linear move")

      {ok(2), _} ->
        some("Clockwise circular move")

      {ok(3), _} ->
        some("Counterclockwise circular move")

      {ok(4), _} ->
        some("Dwell")

      {ok(5), _} ->
        some("High-precision contour control")

      {ok(5.1), _} ->
        some("AI advanced preview control")

      {ok(6.1), _} ->
        some("NURBS machining")

      {ok(7), _} ->
        some("Imaginary axis designation")

      {ok(9), _} ->
        some("Exact stop check - non-modal")

      {ok(10), _} ->
        some("Programmable data input")

      {ok(11), _} ->
        some("Data write cancel")

      {ok(17), _} ->
        some("XY plane selection")

      {ok(18), _} ->
        some("ZX plane selection")

      {ok(19), _} ->
        some("YZ plane selection")

      {ok(20), _} ->
        some("Unit is inches")

      {ok(21), _} ->
        some("Unit is mm")

      {ok(28), _} ->
        some("Return to home position")

      {ok(30), _} ->
        some("Return to secondary home position")

      {ok(31), _} ->
        some("Feed until skip function")

      {ok(32), _} ->
        some("Single-point threading")

      {ok(33), _} ->
        some("Variable pitch threading")

      {ok(40), _} ->
        some("Tool radius compensation off")

      {ok(41), _} ->
        some("Tool radius compensation left")

      {ok(42), _} ->
        some("Tool radius compensation right")

      {ok(43), _} ->
        some("Tool height offset compensation negative")

      {ok(44), _} ->
        some("Tool height offset compensation positive")

      {ok(45), _} ->
        some("Axis offset single increase")

      {ok(46), _} ->
        some("Axis offset single decrease")

      {ok(47), _} ->
        some("Axis offset double increase")

      {ok(48), _} ->
        some("Axis offset double decrease")

      {ok(49), _} ->
        some("Tool length offset compensation cancel")

      {ok(50), %{operation: :turning}} ->
        some("Position register")

      {ok(50), _} ->
        some("Scaling function cancel")

      {ok(52), _} ->
        some("Local coordinate system")

      {ok(53), _} ->
        some("Machine coordinate system")

      {ok(address), _} when address in [54, 55, 56, 57, 58, 59, 54.1] ->
        some("Work coordinate system")

      {ok(61), _} ->
        some("Exact stop check - modal")

      {ok(62), _} ->
        some("Automatic corner override")

      {ok(64), _} ->
        some("Default cutting mode")

      {ok(68), _} ->
        some("Rotate coordinate system")

      {ok(69), _} ->
        some("Turn off coordinate system rotation")

      {ok(70), %{operation: :turning}} ->
        some("Fixed cycle, multiple repetitive cycle - for finishing")

      {ok(71), %{operation: :turning}} ->
        some("Fixed cycle, multiple repetitive cycle - for roughing with Z axis emphasis")

      {ok(72), %{operation: :turning}} ->
        some("Fixed cycle, multiple repetitive cycle - for roughing with X axis emphasis")

      {ok(73), %{operation: :turning}} ->
        some("Fixed cycle, multiple repetitive cycle - for roughing with pattern repetition")

      {ok(73), _} ->
        some("Peck drilling cycle")

      {ok(74), %{operation: :turning}} ->
        some("Peck drilling cycle")

      {ok(74), _} ->
        some("Tapping cycle")

      {ok(75), %{operation: :turning}} ->
        some("Peck grooving cycle")

      {ok(76), %{operation: :turning}} ->
        some("Threading cycle")

      {ok(76), _} ->
        some("Fine boring cycle")

      {ok(80), _} ->
        some("Cancel cycle")

      {ok(81), _} ->
        some("Simple drilling cycle")

      {ok(82), _} ->
        some("Drilling cycle with dwell")

      {ok(83), _} ->
        some("Peck drilling cycle")

      {ok(84), _} ->
        some("Tapping cycle, righthand thread, M03 spindle direction")

      {ok(84.2), _} ->
        some("Tapping cycle, righthand thread, M03 spindle direction, rigid toolholder")

      {ok(84.3), _} ->
        some("Tapping cycle, lefthand thread, M04 spindle direction, rigid toolholder")

      {ok(85), _} ->
        some("Boring cycle, feed in/feed out")

      {ok(86), _} ->
        some("Boring cycle, feed in/spindle stop/rapid out")

      {ok(87), _} ->
        some("Boring cycle, backboring")

      {ok(88), _} ->
        some("Boring cycle, feed in/spindle stop/manual operation")

      {ok(89), _} ->
        some("Boring cycle, feed in/dwell/feed out")

      {ok(90), _} ->
        some("Absolute positioning")

      {ok(91), _} ->
        some("Relative positioning")

      {ok(92), _} ->
        some("Position register")

      {ok(94), _} ->
        some("Feedrate per minute")

      {ok(95), _} ->
        some("Feedrate per revolution")

      {ok(96), _} ->
        some("Constant surface speed")

      {ok(97), _} ->
        some("Constant spindle speed")

      {ok(98), %{operation: :turning}} ->
        some("Feedrate per minute")

      {ok(98), _} ->
        some("Return to initial Z level in canned cycle")

      {ok(99), %{operation: :turning}} ->
        some("Feedrate per revolution")

      {ok(99), _} ->
        some("Return to R level in canned cycle")

      {ok(100), _} ->
        some("Tool length measurement")

      _ ->
        none()
    end
  end

  defp do_describe(%Word{word: "H", address: length}, options) do
    case distance_with_unit(length, options) do
      ok(length) -> some("Tool length offset #{length}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "I", address: offset}, options) do
    case distance_with_unit(offset, options) do
      ok(offset) -> some("X arc center offset #{offset}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "J", address: offset}, options) do
    case distance_with_unit(offset, options) do
      ok(offset) -> some("Y arc center offset #{offset}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "K", address: offset}, options) do
    case distance_with_unit(offset, options) do
      ok(offset) -> some("Z arc center offset #{offset}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "L", address: count}, _) do
    case Expr.evaluate(count) do
      ok(count) -> some("Loop count #{count}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "M", address: address}, options) do
    case {Expr.evaluate(address), options} do
      {ok(0), _} ->
        some("Compulsory stop")

      {ok(1), _} ->
        some("Optional stop")

      {ok(2), _} ->
        some("End of program")

      {ok(3), _} ->
        some("Spindle on clockwise")

      {ok(4), _} ->
        some("Spindle on counterclockwise")

      {ok(5), _} ->
        some("Spindle stop")

      {ok(6), _} ->
        some("Automatic tool change")

      {ok(7), _} ->
        some("Coolant mist")

      {ok(8), _} ->
        some("Coolant flood")

      {ok(9), _} ->
        some("Coolant off")

      {ok(10), _} ->
        some("Pallet clamp on")

      {ok(11), _} ->
        some("Pallet clamp off")

      {ok(13), _} ->
        some("Spindle on clockwise and coolant flood")

      {ok(19), _} ->
        some("Spindle orientation")

      {ok(21), %{operation: :turning}} ->
        some("Tailstock forward")

      {ok(21), _} ->
        some("Mirror X axis")

      {ok(22), %{operation: :turning}} ->
        some("Tailstock backward")

      {ok(22), _} ->
        some("Mirror Y axis")

      {ok(23), %{operation: :turning}} ->
        some("Thread gradual pullout on")

      {ok(23), _} ->
        some("Mirror off")

      {ok(24), %{operation: :turning}} ->
        some("Thread gradual pullout off")

      {ok(30), _} ->
        some("End of program")

      {ok(gear), %{operation: :turning}} when gear > 40 and gear < 45 ->
        some("Gear select #{gear - 40}")

      {ok(48), _} ->
        some("Feedrate override allowed")

      {ok(49), _} ->
        some("Feedrate override not allowed")

      {ok(52), _} ->
        some("Unload tool")

      {ok(60), _} ->
        some("Automatic pallet change")

      {ok(98), _} ->
        some("Subprogram call")

      {ok(99), _} ->
        some("Subprogram end")

      {ok(100), _} ->
        some("Clean nozzle")

      _ ->
        none()
    end
  end

  defp do_describe(%Word{word: "N", address: line}, _) do
    case Expr.evaluate(line) do
      ok(line) -> some("Line #{line}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "O", address: name}, _) do
    case Expr.evaluate(name) do
      ok(name) -> some("Program #{name}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "P", address: param}, _) do
    case Expr.evaluate(param) do
      ok(param) -> some("Parameter #{param}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "Q", address: distance}, options) do
    case distance_with_unit(distance, options) do
      ok(distance) -> some("Peck increment #{distance}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "R", address: distance}, options) do
    case distance_with_unit(distance, options) do
      ok(distance) -> some("Radius #{distance}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "S", address: speed}, _) do
    case Expr.evaluate(speed) do
      ok(speed) -> some("Speed #{speed}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: "T", address: tool}, _) do
    case Expr.evaluate(tool) do
      ok(tool) -> some("Tool #{tool}")
      _ -> none()
    end
  end

  defp do_describe(%Word{word: axis, address: distance}, options) when axis in ~w[X Y Z] do
    case distance_with_unit(distance, options) do
      ok(distance) -> some("#{axis} #{distance}")
      _ -> none()
    end
  end

  defp do_describe(%Word{}, _options), do: none()

  defp distance_with_unit(distance, %{units: :mm}) when is_number(distance),
    do: some("#{distance}mm")

  defp distance_with_unit(distance, %{units: :inches}) when is_number(distance),
    do: some("#{distance}\"")

  defp distance_with_unit(distance, _) when is_number(distance),
    do: some(to_string(distance))

  defp distance_with_unit(distance, options) when is_expression(distance) do
    case Expr.evaluate(distance) do
      ok(distance) when is_number(distance) -> distance_with_unit(distance, options)
      _ -> none()
    end
  end

  defp distance_with_unit(_, _), do: none()

  defp feedrate(distance, %{operation: :turning} = options) do
    case distance_with_unit(distance, options) do
      some(distance) -> some("#{distance}/rev")
      _ -> none()
    end
  end

  defp feedrate(distance, options) do
    case distance_with_unit(distance, options) do
      some(distance) -> some("#{distance}/min")
      _ -> none()
    end
  end
end
