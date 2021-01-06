defmodule Gcode.Model.Expr.String do
  alias Gcode.Model.Expr.String
  use Gcode.Option
  use Gcode.Result
  defstruct value: Option.none()

  @moduledoc """
  Represents a string expression in G-code.
  """

  @type t :: %String{
          value: Option.t(String.t())
        }

  @doc """
  Initialise a comment.

  ## Example

      iex> "Doc, in the carpark, with plutonium"
      ...> |> String.init()
      {:ok, %String{value: "Doc, in the carpark, with plutonium"}}
  """
  @spec init(Elixir.String.t()) :: Result.t(t)
  def init(comment) when is_binary(comment) do
    if Elixir.String.printable?(comment) do
      ok(%String{value: comment})
    else
      error(
        {:string_error, "String should be a valid UTF-8 string, received #{inspect(comment)}"}
      )
    end
  end

  def init(comment),
    do:
      error(
        {:string_error, "String should be a valid UTF-8 string, received #{inspect(comment)}"}
      )
end
