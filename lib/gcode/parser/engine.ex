defmodule Gcode.Parser.Engine do
  import NimbleParsec
  use Gcode.Result

  @moduledoc """
  A parser for G-code programs using Parsec.
  """

  defcombinatorp(
    :whitespace,
    [
      string(" "),
      string("\t")
    ]
    |> choice()
    |> repeat()
    |> ignore()
  )

  defcombinatorp(
    :whitespace?,
    optional(parsec(:whitespace))
  )

  defcombinatorp(
    :newline,
    [string("\r"), string("\n")] |> choice() |> times(min: 1) |> tag(:newline)
  )

  defcombinatorp(
    :eol,
    empty()
    |> parsec(:whitespace?)
    |> choice([parsec(:newline), eos()])
  )

  defcombinatorp(
    :tape,
    empty()
    |> ignore(string("%"))
    |> optional(
      parsec(:whitespace?)
      |> repeat(utf8_char([]))
    )
    |> tag(:tape)
  )

  defcombinatorp(
    :braces_comment,
    empty()
    |> ignore(
      string("(")
      |> parsec(:whitespace?)
    )
    |> repeat(
      lookahead_not(
        choice([
          string(")"),
          parsec(:whitespace)
          |> string(")")
        ])
      )
      |> utf8_char([])
    )
    |> tag(:comment)
    |> ignore(
      parsec(:whitespace?)
      |> string(")")
    )
  )

  defcombinatorp(
    :semi_comment,
    empty()
    |> ignore(
      string(";")
      |> parsec(:whitespace?)
    )
    |> repeat(
      lookahead_not(parsec(:eol))
      |> utf8_char([])
    )
    |> tag(:comment)
  )

  defcombinatorp(
    :comment,
    choice([
      parsec(:braces_comment),
      parsec(:semi_comment)
    ])
  )

  defcombinatorp(
    :integer,
    times(
      utf8_char([?0..?9]),
      min: 1
    )
    |> tag(:integer)
  )

  defcombinatorp(
    :float,
    times(utf8_char([?0..?9]), min: 1)
    |> utf8_char([?.])
    |> times(utf8_char([?0..?9]), min: 1)
    |> tag(:float)
  )

  defcombinatorp(
    :number,
    choice([
      parsec(:float),
      parsec(:integer)
    ])
  )

  defcombinator(
    :constant,
    choice([
      choice([
        string("true"),
        string("false")
      ])
      |> tag(:boolean),
      string("iterations")
      |> tag(:iterations),
      string("line")
      |> tag(:line),
      string("pi")
      |> tag(:pi),
      string("result")
      |> tag(:result)
    ])
    |> tag(:constant)
  )

  defcombinator(
    :prefix,
    choice([
      ignore(string("!") |> parsec(:whitespace?)) |> tag(parsec(:expression), :!),
      ignore(string("+") |> parsec(:whitespace?)) |> tag(parsec(:expression), :+),
      ignore(string("-") |> parsec(:whitespace?)) |> tag(parsec(:expression), :-),
      ignore(string("#") |> parsec(:whitespace?)) |> tag(parsec(:expression), :"#")
    ])
  )

  defcombinator(
    :expression,
    choice([
      parsec(:prefix),
      parsec(:number),
      parsec(:constant)
    ])
  )

  defcombinatorp(
    :bare_string,
    times(
      lookahead_not(
        parsec(:whitespace?)
        |> choice([
          parsec(:newline),
          parsec(:comment)
        ])
      )
      |> utf8_char([]),
      min: 1
    )
    |> tag(:string)
  )

  defcombinatorp(
    :quoted_string,
    ignore(string("\""))
    |> repeat(
      lookahead_not(
        choice([
          parsec(:newline),
          string("\"")
        ])
      )
      |> utf8_char([])
    )
    |> tag(:string)
    |> ignore(optional(string("\"")))
  )

  defcombinatorp(:string, choice([parsec(:quoted_string), parsec(:bare_string)]))

  defcombinatorp(
    :word,
    empty()
    |> utf8_char([?A..?Z])
    |> tag(:command)
    |> parsec(:whitespace?)
    |> tag(
      parsec(:expression),
      :address
    )
    |> tag(:word)
  )

  defcombinatorp(
    :block,
    empty()
    |> times(
      choice([
        parsec(:word),
        parsec(:string)
      ])
      |> parsec(:whitespace?),
      min: 1
    )
    |> optional(parsec(:comment))
    |> tag(:block)
  )

  defcombinatorp(
    :line,
    choice([
      parsec(:tape),
      parsec(:comment),
      parsec(:block)
    ])
  )

  defparsecp(:program, times(parsec(:line) |> parsec(:eol), min: 1))

  @spec parse(String.t()) :: Result.t(keyword)
  def parse(program) do
    case program(program) do
      {:ok, tokens, _, _, _, _} -> ok(tokens)
      {:error, a, b, c, d, e} -> error({a, b, c, d, e})
    end
  end
end
