defmodule Gcode.Model.Word.SerialiseTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Serialise, Word}
  use Gcode.Result
  @moduledoc false

  describe "serialise/1" do
    test "formats the word and the address correctly" do
      actual =
        with ok(word) <- Word.init("G", 0),
             ok(word) <- Serialise.serialise(word),
             do: word

      expected = ~w[G0]

      assert actual == expected
    end
  end
end
