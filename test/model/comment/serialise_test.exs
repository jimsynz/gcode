defmodule Gcode.Model.Comment.SerialiseTest do
  use ExUnit.Case, async: true
  alias Gcode.Model.{Comment, Serialise}
  @moduledoc false

  describe "serialise/1" do
    test "each line of the comment is wrapped in brackets" do
      {:ok, actual} =
        """
        This
        is
        a
        test
        """
        |> Comment.init()
        |> Serialise.serialise()

      expected = ~w[(This) (is) (a) (test)]

      assert actual == expected
    end
  end
end
