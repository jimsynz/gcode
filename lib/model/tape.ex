defmodule Gcode.Model.Tape do
  defstruct leader: :none
  alias Gcode.{Model.Tape}
  use Gcode.Option
  use Gcode.Result

  @moduledoc """
  The tape (`%`) denotes the beginning and end of the program and is not needed
  by most controllers.  Can optionally contain a comment, called a "leader".
  """

  @type t :: %Tape{leader: Option.t(String.t())}
  @type error :: {:tape_error, String.t()}

  @doc """
  Initialises a tape command, with no "leader"

  ## Example

      iex> Tape.init()
      {:ok, %Tape{leader: :none}}
  """
  @spec init :: Result.t(t)
  def init, do: ok(%Tape{leader: Option.none()})

  @doc """
  Initialises a tape command, with a "leader"

  ## Example

      iex> Tape.init("Marty in the Delorean with the Flux Capacitor")
      {:ok, %Tape{leader: {:ok, "Marty in the Delorean with the Flux Capacitor"}}}
  """
  @spec init(String.t()) :: Result.t(t, error)
  def init(leader) when is_binary(leader) do
    if String.printable?(leader) do
      ok(%Tape{leader: some(leader)})
    else
      error(
        {:tape_error, "Expected leader to be a valid UTF-8 string, recevied #{inspect(leader)}"}
      )
    end
  end

  def init(leader),
    do:
      error(
        {:tape_error, "Expected leader to be a valid UTF-8 string, recevied #{inspect(leader)}"}
      )
end
