defmodule FixtureHelper do
  @moduledoc false

  def read_fixture(name) do
    name
    |> fixture_path()
    |> File.read!()
  end

  def fixture_path(name),
    do:
      :gcode
      |> :code.priv_dir()
      |> List.to_string()
      |> Path.join("fixtures")
      |> Path.join(name)
end
