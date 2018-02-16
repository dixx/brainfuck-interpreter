defmodule BrainfuckTest do
  use ExUnit.Case
  # doctest Brainfuck # <-- skipped for now

  test "returns nothing for an empty program" do
    assert Brainfuck.run("") == {0, [0], ""}
  end

  test "non-Brainfuck chars are ignored" do
    assert Brainfuck.run("++non-Brainfuck chars++") == {0, [3], ""}
  end

  test "+ increments the value at the data pointer location" do
    assert Brainfuck.run("+++") == {0, [3], ""}
  end

  test "- decrements the value at the data pointer location" do
    assert Brainfuck.run("---") == {0, [-3], ""} # TODO should be 253 instead!
  end

  test "> increments the data pointer" do
    assert Brainfuck.run(">>>") == {3, [0, 0, 0, 0], ""}
  end

  test "< decrements the data pointer" do
    assert Brainfuck.run("<<<") == {0, [0, 0, 0, 0], ""}
  end

  test ". output the value at the data pointer as byte" do
    precondition = "++++++++++++++++++++++++++++++++++++++++++" # == 42
    assert Brainfuck.run(precondition <> ".") == {0, [42], "*"}
  end

  @tag :skip
  test ", read a byte into the cell at pointer location" do
  end

  @tag :skip
  test "[ if the current cell value is zero, jump to the next matching ]" do
  end

  @tag :skip
  test "] if the current cell value is non-zero jump back to the matching [" do
  end
end
