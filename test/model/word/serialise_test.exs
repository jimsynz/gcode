defmodule Gcode.Model.Word.SerialiseTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Serialise, Word}
  @moduledoc false

  describe "serialise/1" do
    test "formats the word and the address correctly" do
      {:ok, actual} =
        "G"
        |> Word.init(0)
        |> Serialise.serialise()

      expected = ~w[G0]

      assert actual == expected
    end
  end
end
