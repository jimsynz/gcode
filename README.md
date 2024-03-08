# G-code

[![Build Status](https://drone.harton.dev/api/badges/james/gcode/status.svg?ref=refs/heads/main)](https://drone.harton.dev/james/gcode)
[![Hex.pm](https://img.shields.io/hexpm/v/gcode.svg)](https://hex.pm/packages/gcode)
[![Hippocratic License HL3-FULL](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-FULL&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/full.html)

`gcode` is an Elixir library for parsing and generating [G-code](https://en.wikipedia.org/wiki/G-code), which is a common language for working with CNC machines and 3D printers.

## Installation

Gcode is [available in Hex](https://hex.pm/packages/gcode), the package can be
installed by adding `gcode` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gcode, "~> 1.0.0"}
  ]
end
```

Documentation for the latest release can be found on
[HexDocs](https://hexdocs.pm/gcode) and for the `main` branch on
[docs.harton.nz](https://docs.harton.nz/james/gcode).

## Github Mirror

This repository is mirrored [on Github](https://github.com/jimsynz/gcode)
from it's primary location [on my Forgejo instance](https://harton.dev/james/gcode).
Feel free to raise issues and open PRs on Github.

## License

This software is licensed under the terms of the
[HL3-FULL](https://firstdonoharm.dev), see the `LICENSE.md` file included with
this package for the terms.

This license actively proscribes this software being used by and for some
industries, countries and activities. If your usage of this software doesn't
comply with the terms of this license, then [contact me](mailto:james@harton.nz)
with the details of your use-case to organise the purchase of a license - the
cost of which may include a donation to a suitable charity or NGO.
