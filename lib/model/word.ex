defmodule Gcode.Model.Word do
  alias Gcode.Model.Word
  use Gcode.Option

  defstruct word: none(), address: none()

  @moduledoc """
  A G-code word.
  """

  @type t :: %Word{
          word: Option.some(String.t()),
          address: Option.some(number)
        }

  @doc """
  Initialise a word with a command and an address.

  ## Example

      iex> Word.init("G", 0)
      %Word{word: {:ok, "G"}, address: {:ok, 0}}
  """
  @spec init(String.t(), number) :: t
  def init(word, address) when is_binary(word) and byte_size(word) == 1 and is_number(address),
    do: %Word{word: some(word), address: some(address)}
end
