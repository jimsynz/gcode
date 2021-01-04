defmodule Gcode.Model.Comment do
  alias Gcode.Model.Comment
  use Gcode.Option
  defstruct comment: Option.none()

  @moduledoc """
  A G-code comment.
  """

  @type t :: %Comment{
          comment: Option.t(String.t())
        }

  @doc """
  Initialise a comment.

  ## Example

      iex> "Doc, in the carpark, with plutonium"
      ...> |> Comment.init()
      %Comment{comment: some("Doc, in the carpark, with plutonium")}
  """
  @spec init(String.t()) :: t
  def init(comment) when is_binary(comment), do: %Comment{comment: Option.some(comment)}
end
