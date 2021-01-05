defmodule Gcode.Model.Word do
  alias Gcode.Model.Word
  use Gcode.Option
  use Gcode.Result

  defstruct word: none(), address: none()

  @moduledoc """
  A G-code word.
  """

  @type t :: %Word{
          word: String.t(),
          address: number
        }

  @doc """
  Initialise a word with a command and an address.

  ## Example

      iex> Word.init("G", 0)
      {:ok, %Word{word: "G", address: 0}}
  """
  @spec init(String.t(), number) :: Result.t(t)
  def init(word, address) when is_binary(word) and is_number(address) do
    if Regex.match?(~r/^[A-Z]$/, word) do
      ok(%Word{word: word, address: address})
    else
      error({:word_error, "Expected word to be a single character, received #{inspect(word)}"})
    end
  end

  def init(word, address) when is_number(address),
    do: error({:word_error, "Expected word to be a string, received #{inspect(word)}"})

  def init(_word, address),
    do: error({:word_error, "Expected address to be a number, received #{inspect(address)}"})
end
