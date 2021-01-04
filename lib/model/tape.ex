defmodule Gcode.Model.Tape do
  defstruct leader: :none
  alias Gcode.{Model.Tape}
  use Gcode.Option

  @moduledoc """
  The tape (`%`) denotes the beginning and end of the program and is not needed
  by most controllers.  Can optionally contain a comment, called a "leader".
  """

  @type t :: %Tape{leader: Option.t(String.t())}

  @doc """
  Initialises a tape command, with no "leader"

  ## Example

      iex> Tape.init()
      %Tape{leader: :none}
  """
  @spec init :: t
  def init, do: %Tape{leader: Option.none()}

  @doc """
  Initialises a tape command, with a "leader"

  ## Example

      iex> Tape.init("Marty in the Delorean with the Flux Capacitor")
      %Tape{leader: {:ok, "Marty in the Delorean with the Flux Capacitor"}}
  """
  @spec init(String.t()) :: t
  def init(leader) when is_binary(leader), do: %Tape{leader: Option.some(leader)}
end
