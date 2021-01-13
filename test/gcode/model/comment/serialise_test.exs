defmodule Gcode.Model.Comment.SerialiseTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Comment, Serialise}
  use Gcode.Result
  @moduledoc false

  describe "serialise/1" do
    test "each line of the comment is wrapped in brackets" do
      comment = """
      This
      is
      a
      test
      """

      actual =
        with ok(comment) <- Comment.init(comment),
             ok(comment) <- Serialise.serialise(comment),
             do: comment

      expected = ~w[(This) (is) (a) (test)]

      assert actual == expected
    end
  end
end
