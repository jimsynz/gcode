defmodule Gcode.Model.Skip.SerialiseTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Serialise, Skip}
  use Gcode.Result
  @moduledoc false

  describe "serialise/1" do
    test "when the skip has a number, it formats it correctly" do
      actual =
        with ok(skip) <- Skip.init(0),
             ok(skip) <- Serialise.serialise(skip),
             do: skip

      expected = ~w[/0]

      assert actual == expected
    end

    test "when the skip has no number, it formats it correctly" do
      actual =
        with ok(skip) <- Skip.init(),
             ok(skip) <- Serialise.serialise(skip),
             do: skip

      expected = ~w[/]

      assert actual == expected
    end
  end
end
