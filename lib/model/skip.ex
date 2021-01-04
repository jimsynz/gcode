defmodule Gcode.Model.Skip do
  alias Gcode.Model.Skip
  use Gcode.Option
  use Gcode.Result
  defstruct number: Option.none()

  @moduledoc """
  A G-code skip.
  """

  @type t :: %Skip{
          number: Option.t(non_neg_integer)
        }

  @type error :: {:skip_error, String.t()}

  @doc """
  Initialise a skip with a number.

  ## Example

      iex> 13
      ...> |> Skip.init()
      {:ok, %Skip{number: some(13)}}
  """
  @spec init(non_neg_integer) :: Result.t(t, error)
  def init(number) when is_integer(number) and number >= 0,
    do: ok(%Skip{number: Option.some(number)})

  def init(number),
    do: error({:skip_error, "Expected a positive integer, received #{inspect(number)}"})

  @doc """
  Initialise a skip without a number.

  ## Example

      iex> Skip.init()
      {:ok, %Skip{number: none()}}
  """
  @spec init :: Result.t(t)
  def init, do: ok(%Skip{})
end
