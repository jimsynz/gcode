defmodule Gcode.Model.Skip.SerialiseTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Serialise, Skip}
  @moduledoc false

  describe "serialise/1" do
    test "when the skip has a number, it formats it correctly" do
      {:ok, actual} =
        Skip.init(0)
        |> Serialise.serialise()

      expected = ~w[/0]

      assert actual == expected
    end

    test "when the skip has no number, it formats it correctly" do
      {:ok, actual} =
        Skip.init()
        |> Serialise.serialise()

      expected = ~w[/]

      assert actual == expected
    end
  end
end
