defmodule Brainfuck do
  @moduledoc """
  Brainfuck interpreter written in Elixir.
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
end
