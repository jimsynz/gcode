defmodule Gcode.Model.Block do
  use Gcode.Option
  use Gcode.Result
  defstruct words: [], comment: none()
  import Gcode.Model.Expr.Helpers
  alias Gcode.Model.{Block, Comment, Expr, Skip, Word}

  defguardp is_pushable(value)
            when is_struct(value, Block) or is_struct(value, Comment) or is_struct(value, Skip) or
                   is_struct(value, Word) or is_expression(value)

  @moduledoc """
  A sequence of G-code words on a single line.
  """

  @type t :: %Block{words: [block_contents], comment: Option.t(Comment)}
  @typedoc "Any error results in this module will return this type"
  @type block_error :: {:block_error, String.t()}
  @type block_contents :: Word.t() | Skip.t() | Expr.t()

  @doc """
  Initialise a new empty G-code program.

  ## Example

      iex> Block.init()
      {:ok, %Block{words: [], comment: none()}}
  """
  @spec init :: Result.t(t)
  def init, do: ok(%Block{words: [], comment: none()})

  @doc """
  Set a comment on the block (this is just a sugar to make sure that the comment
  is rendered on the same line as the block).

  *Note:* Once a block has a comment set, it cannot be overwritten.

  ## Examples

      iex> {:ok, comment} = Comment.init("Jen, in the swing seat, with her night terrors")
      ...> {:ok, block} = Block.init()
      ...> {:ok, block} = Block.comment(block, comment)
      ...> Result.ok?(block.comment)
      true
  """
  @spec comment(t, Comment.t()) :: Result.t(t, block_error)
  def comment(%Block{} = block, comment),
    do: ok(%Block{block | comment: some(comment)})

  @doc """
  Pushes a `Word` onto the word list.

  *Note:* `Block` stores the words in reverse order because of Erlang list
  semantics, you should pretty much always use `words/1` to retrieve them in the
  correct order.

  ## Example

      iex> {:ok, block} = Block.init()
      ...> {:ok, word} = Word.init("G", 0)
      ...> {:ok, block} = Block.push(block, word)
      ...> {:ok, word} = Word.init("N", 100)
      ...> Block.push(block, word)
      {:ok, %Block{words: [%Word{word: "N", address: %Integer{i: 100}}, %Word{word: "G", address: %Integer{i: 0}}]}}
  """
  @spec push(t, block_contents) :: Result.t(t, block_error)
  def push(%Block{words: words} = block, pushable)
      when is_pushable(pushable) and is_list(words),
      do: ok(%Block{block | words: [pushable | words]})

  def push(%Block{words: words}, pushable) when is_pushable(pushable),
    do:
      error(
        {:block_error,
         "Expected block to contain a list of words, but it contains #{inspect(words)}"}
      )

  def push(%Block{words: words}, pushable) when is_list(words),
    do:
      error(
        {:block_error,
         "Expected element to be pushable, but it is not. Received #{inspect(pushable)}"}
      )

  @doc """
  An accessor which returns the block's words in the correct order.

      iex> {:ok, block} = Block.init()
      ...> {:ok, word} = Word.init("G", 0)
      ...> {:ok, block} = Block.push(block, word)
      ...> {:ok, word} = Word.init("N", 100)
      ...> {:ok, block} = Block.push(block, word)
      ...> Block.words(block)
      {:ok, [%Word{word: "G", address: %Integer{i: 0}}, %Word{word: "N", address: %Integer{i: 100}}]}
  """
  @spec words(t) :: Result.t([Word.t()], block_error)
  def words(%Block{words: words}) when is_list(words), do: ok(Enum.reverse(words))

  def words(%Block{words: words}),
    do:
      error(
        {:block_error,
         "Expected block to contain a list of words, but it contains #{inspect(words)}"}
      )
end
