defmodule Gcode.Model.Comment do
  alias Gcode.Model.Comment
  use Gcode.Option
  use Gcode.Result
  defstruct comment: Option.none()

  @moduledoc """
  A G-code comment.
  """

  @type t :: %Comment{
          comment: String.t()
        }

  @type error :: {:comment_error, String.t()}

  @doc """
  Initialise a comment.

  ## Example

      iex> "Doc, in the carpark, with plutonium"
      ...> |> Comment.init()
      {:ok, %Comment{comment: "Doc, in the carpark, with plutonium"}}
  """
  @spec init(String.t()) :: Result.t(t, error)
  def init(comment) when is_binary(comment) do
    if String.printable?(comment) do
      ok(%Comment{comment: comment})
    else
      error(
        {:comment_error,
         "Expected comment should be a valid UTF-8 string, received #{inspect(comment)}"}
      )
    end
  end

  def init(comment),
    do:
      error(
        {:comment_error,
         "Expected comment should be a valid UTF-8 string, received #{inspect(comment)}"}
      )
end
