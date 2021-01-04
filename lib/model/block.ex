defmodule Gcode.Model.Block do
  use Gcode.Option
  use Gcode.Result
  defstruct words: [], comment: none()
  alias Gcode.Model.{Block, Comment, Skip, Word}

  @moduledoc """
  A sequence of G-code words.
  """

  @type t :: %Block{words: [block_contents], comment: Option.t(Comment)}
  @typedoc "Any error results in this module will return this type"
  @type block_error :: {:block_error, String.t()}
  @type block_contents :: Word.t() | Skip.t()

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

      iex> {:ok, comment} = Comment.init("Jen, in the swing seat, with her night terrors")
      ...> {:ok, block} = Block.init()
      ...> {:ok, block} = Block.comment(block, comment)
      ...> Block.comment(block, comment)
      {:error, {:block_error, "Block already contains a comment"}}

  """
  @spec comment(t, Comment.t()) :: Result.t(t, block_error)
  def comment(%Block{comment: none()} = block, %Comment{comment: some(_)} = comment),
    do: {:ok, %Block{block | comment: some(comment)}}

  def comment(%Block{comment: some(_)}, _comment),
    do: {:error, {:block_error, "Block already contains a comment"}}

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
      {:ok, %Block{words: [%Word{word: some("N"), address: some(100)}, %Word{word: some("G"), address: some(0)}]}}
  """
  @spec push(t, block_contents) :: Result.t(t, block_error)
  def push(%Block{words: words} = block, word)
      when (is_struct(word, Word) or is_struct(word, Skip)) and is_list(words),
      do: {:ok, %Block{block | words: [word | words]}}

  def push(%Block{words: words}, word)
      when (is_struct(word, Word) or is_struct(word, Skip)) and is_list(words),
      do:
        {:error,
         {:block_error,
          "Expected block to contain a list of words, but it contains #{inspect(words)}"}}

  @doc """
  An accessor which returns the block's words in the correct order.

      iex> {:ok, block} = Block.init()
      ...> {:ok, word} = Word.init("G", 0)
      ...> {:ok, block} = Block.push(block, word)
      ...> {:ok, word} = Word.init("N", 100)
      ...> {:ok, block} = Block.push(block, word)
      ...> Block.words(block)
      {:ok, [%Word{word: some("G"), address: some(0)}, %Word{word: some("N"), address: some(100)}]}
  """
  @spec words(t) :: Result.t([Word.t()], block_error)
  def words(%Block{words: words}) when is_list(words), do: {:ok, Enum.reverse(words)}

  def words(%Block{words: words}),
    do:
      {:error,
       {:block_error,
        "Expected block to contain a list of words, but it contains #{inspect(words)}"}}
end
