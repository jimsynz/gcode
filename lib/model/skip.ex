defmodule Gcode.Model.Skip do
  alias Gcode.Model.Skip
  use Gcode.Option
  defstruct number: Option.none()

  @moduledoc """
  A G-code skip.
  """

  @type t :: %Skip{
          number: Option.t(non_neg_integer)
        }

  @doc """
  Initialise a skip with a number.

  ## Example

      iex> 13
      ...> |> Skip.init()
      %Skip{number: some(13)}
  """
  @spec init(non_neg_integer) :: t
  def init(number) when is_number(number) and number >= 0, do: %Skip{number: Option.some(number)}

  @doc """
  Initialise a skip without a number.

  ## Example

      iex> Skip.init()
      %Skip{number: none()}
  """
  @spec init :: t
  def init, do: %Skip{}
end
