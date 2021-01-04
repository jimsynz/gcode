defmodule Gcode.Model.Program do
  defstruct elements: []
  alias Gcode.Model.{Block, Program, Tape}

  @moduledoc """
  A G-code program is the high level object which contains each of the G-code
  blocks, comments, etc.

  ## Example

      iex> Program.init()
      ...> |> Enum.count()
      0
  """

  @typedoc "A G-code program"
  @type t :: %Program{
          elements: [element]
        }

  @type element :: Block.t() | Comment.t() | Tape.t()

  @doc """
  Initialise a new, empty G-code program.

      iex> Program.init()
      %Program{elements: []}
  """
  @spec init :: t()
  def init, do: %Program{}

  @doc """
  Push a program element onto the end of the program.

      iex> Program.init()
      ...> |> Program.push(Tape.init())
      {:ok, %Program{elements: [%Tape{}]}}
  """
  @spec push(t, element) :: {:ok, t} | {:error, any}
  def push(%Program{elements: elements} = program, element),
    do: {:ok, %Program{program | elements: [element | elements]}}
end
