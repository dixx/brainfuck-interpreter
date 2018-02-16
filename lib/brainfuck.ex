defmodule Brainfuck do
  @moduledoc """
  Brainfuck interpreter written in Elixir. I used this tutorial: https://dev.mikamai.com/2014/10/15/elixir-as-a-parsing-tool-writing-a-brainfuck-2/
  """

  @doc """
  the main routine to run a Brainfuck program.
  ## Examples
    iex> Brainfuck.run("++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.")
    "Hello World!"
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

  # ignore non-Brainfuck chars
  defp run(<<_>> <> rest, address, mem, output), do: run(rest, address, mem, output)

  defp increase_at(list, address), do: List.update_at(list, address, &(&1 + 1 |> rem(255)))
  defp decrease_at(list, address), do: List.update_at(list, address, &(&1 - 1 |> rem(255)))
  defp byte_at(list, address), do: list |> Enum.at(address)
  defp char_at(list, address), do: [list |> byte_at(address)] |> to_string
end
