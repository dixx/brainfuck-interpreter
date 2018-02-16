defmodule BrainfuckTest do
  use ExUnit.Case
  # doctest Brainfuck # <-- skipped for now

  test "returns nothing for an empty program" do
    assert Brainfuck.run("") == {0, [0], ""}
  end
end
