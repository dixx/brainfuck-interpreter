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

  # no more Brainfuck found, output result and exit
  defp run("", address, mem, output), do: {address, mem, output}

  # go forth in memory
  defp run(">" <> rest, address, mem, output) when length(mem) == address + 1 do
    # add a cell to the end
    run(rest, address + 1, mem ++ [0], output)
  end
  defp run(">" <> rest, address, mem, output), do: run(rest, address + 1, mem, output)

  # go back in memory
  defp run("<" <> rest, address, mem, output) when address == 0 do
    # add a cell before the start
    run(rest, 0, [0] ++ mem, output)
  end
  defp run("<" <> rest, address, mem, output), do: run(rest, address - 1, mem, output)

  # increase value at current address
  defp run("+" <> rest, address, mem, output), do: run(rest, address, mem |> increase_at(address), output)

  # decrease value at current address
  defp run("-" <> rest, address, mem, output), do: run(rest, address, mem |> decrease_at(address), output)

  # output value at current address
  defp run("." <> rest, address, mem, output), do: run(rest, address, mem, output <> (mem |> char_at(address)))

  # start loop
  defp run("[" <> rest, address, mem, output) do
    case mem |> byte_at(address) do
      0 -> run(rest |> jump_to_end, address, mem, output)
      _ ->
        {a,m,o} = run(rest |> loop_body, address, mem, output)
        # prepend [ to the input, to make sure we call this function again
        run("[" <> rest, a, m, o)
    end
  end

  # ignore non-Brainfuck chars
  defp run(<<_>> <> rest, address, mem, output), do: run(rest, address, mem, output)

  defp increase_at(list, address), do: List.update_at(list, address, &(&1 + 1 |> mod(255)))
  defp decrease_at(list, address), do: List.update_at(list, address, &(&1 - 1 |> mod(255)))
  defp byte_at(list, address), do: list |> Enum.at(address)
  defp char_at(list, address), do: [list |> byte_at(address)] |> to_string

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
