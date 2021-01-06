defmodule Gcode.Model.Program do
  defstruct elements: []
  alias Gcode.Model.{Block, Comment, Program, Tape}
  use Gcode.Result

  @moduledoc """
  A G-code program is the high level object which contains each of the G-code
  blocks, comments, etc.

  ## Example

      iex> Program.init()
      ...> |> Result.unwrap!()
      ...> |> Enum.count()
      0
  """

  @typedoc "A G-code program"
  @type t :: %Program{
          elements: [element]
        }

  @type element :: Block.t() | Comment.t() | Tape.t()
  @type error :: {:program_error, String.t()}

  @doc """
  Initialise a new, empty G-code program.

      iex> Program.init()
      {:ok, %Program{elements: []}}
  """
  @spec init :: Result.t(t())
  def init, do: ok(%Program{})

  @doc """
  Push a program element onto the end of the program.

      iex> {:ok, program} = Program.init()
      ...> {:ok, tape} = Tape.init()
      ...> Program.push(program, tape)
      {:ok, %Program{elements: [%Tape{}]}}
  """
  @spec push(t, element) :: Result.t(t, error)
  def push(%Program{elements: elements} = program, element)
      when is_list(elements) and
             (is_struct(element, Block) or is_struct(element, Comment) or is_struct(element, Tape)),
      do: ok(%Program{program | elements: [element | elements]})

  def push(%Program{elements: elements}, _element) when not is_list(elements),
    do: error({:program_error, "Program elements is not a list"})

  def push(%Program{}, element),
    do: error({:program_error, "Expected a valid program element, received #{inspect(element)}"})

  def push(program, _element),
    do: error({:program_error, "Expected a valid program, received #{inspect(program)}"})
end
