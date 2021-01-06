defmodule Gcode.MixProject do
  use Mix.Project
  @moduledoc false

  @version "0.3.0"
  @description """
  A G-code parser and generator.
  """

  def project do
    [
      app: :gcode,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: @description,
      deps: deps(),
      consolidate_protocols: Mix.env() != :test,
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def package do
    [
      maintainers: ["James Harton <james@harton.nz>"],
      licenses: ["Hippocratic"],
      links: %{
        "Source" => "https://gitlab.com/jimsy/gcode"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: ~w[dev test]a, runtime: false},
      {:earmark, ">= 0.0.0", only: ~w[dev test]a, runtime: false},
      {:credo, "~> 1.1", only: ~w[dev test]a, runtime: false},
      {:git_ops, "~> 2.3", only: ~w[dev test]a, runtime: false},
      {:nimble_parsec, "~> 1.1"},
      {:parallel_stream, "~> 1.0"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
