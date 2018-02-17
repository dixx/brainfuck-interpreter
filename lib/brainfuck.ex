defmodule Brainfuck do
  @moduledoc """
  Brainfuck interpreter written in Elixir. I used this tutorial: https://dev.mikamai.com/2014/10/15/elixir-as-a-parsing-tool-writing-a-brainfuck-2/
  """

  @doc """
  the main routine to run a Brainfuck program.
  ## Examples
    iex> Brainfuck.run("++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.")
    {6, [0, 0, 72, 100, 87, 33, 10], "Hello World!\\n"}
  """
  def run(program), do: run(program, 0, [0], "")

  defp run("", addr, mem, output), do: {addr, mem, output}
  defp run(">" <> rest, addr, mem, output) when length(mem) == addr + 1, do: run(rest, addr + 1, mem ++ [0], output)
  defp run(">" <> rest, addr, mem, output), do: run(rest, addr + 1, mem, output)
  defp run("<" <> rest, addr, mem, output) when addr == 0, do: run(rest, 0, [0] ++ mem, output)
  defp run("<" <> rest, addr, mem, output), do: run(rest, addr - 1, mem, output)
  defp run("+" <> rest, addr, mem, output), do: run(rest, addr, mem |> increase_at(addr), output)
  defp run("-" <> rest, addr, mem, output), do: run(rest, addr, mem |> decrease_at(addr), output)
  defp run("." <> rest, addr, mem, output), do: run(rest, addr, mem, output <> (mem |> char_at(addr)))

  # start loop
  defp run("[" <> rest, addr, mem, output) do
    case mem |> byte_at(addr) do
      0 -> run(rest |> jump_to_end, addr, mem, output)
      _ ->
        {a,m,o} = run(rest |> loop_body, addr, mem, output)
        # prepend [ to the input, to make sure we call this function again
        run("[" <> rest, a, m, o)
    end
  end

  # ignore non-Brainfuck chars
  defp run(<<_>> <> rest, addr, mem, output), do: run(rest, addr, mem, output)

  defp increase_at(list, addr), do: List.update_at(list, addr, &(&1 + 1 |> mod(255)))
  defp decrease_at(list, addr), do: List.update_at(list, addr, &(&1 - 1 |> mod(255)))
  defp byte_at(list, addr), do: list |> Enum.at(addr)
  defp char_at(list, addr), do: [list |> byte_at(addr)] |> to_string

  # start the matching loop
  defp match_lend(source), do: match_lend(source, 1, 0)

  # if depth is zero, we have reached the other end of the loop
  # return the body length
  defp match_lend(_, 0, acc), do: acc

  # if we reached the end of the input, but depth is not zero, the
  # sequence is unbalanced, raise an error
  defp match_lend("", _, _), do: raise "unbalanced loop"

  # [ increment the depth
  defp match_lend("[" <> rest, depth, acc), do: match_lend(rest, depth + 1, acc + 1)
  # ] decrement the depth
  defp match_lend("]" <> rest, depth, acc), do: match_lend(rest, depth - 1, acc + 1)
  # every other character just increment acc (loop body length)
  defp match_lend(<<_>> <> rest, depth, acc), do: match_lend(rest, depth, acc + 1)

  defp jump_to_end(source), do: source |> String.slice((source |> match_lend)..-1)
  defp loop_body(source), do: source |> String.slice(0..((source |> match_lend) - 1))

  defp mod(x, y) when x > 0, do: rem(x, y);
  defp mod(x, y) when x < 0, do: rem(x + 1, y) + y;
  defp mod(0, _y), do: 0
end
