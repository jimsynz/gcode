defmodule Gcode.MixProject do
  use Mix.Project
  @moduledoc false

  @version "1.0.1"
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
      elixirc_paths: elixirc_paths(Mix.env()),
      docs: [
        main: "readme",
        extras: ["README.md", "CHANGELOG.md"]
      ]
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
      licenses: ["HL3-FULL"],
      links: %{
        "Source" => "https://harton.dev/james/gcode",
        "GitHub" => "https://github.com/jimsynz/gcode",
        "Changelog" => "https://docs.harton.nz/james/gcode/changelog.html",
        "Sponsor" => "https://github.com/sponsors/jimsynz"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_parsec, "~> 1.2"},
      {:parallel_stream, "~> 1.1"},

      # Dev/test
      {:credo, "~> 1.6", only: ~w[dev test]a, runtime: false},
      {:ex_check, "~> 0.15", only: ~w[dev test]a, runtime: false},
      {:ex_doc, "~> 0.39", only: ~w[dev test]a, runtime: false},
      {:git_ops, "~> 2.4", only: ~w[dev test]a, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
