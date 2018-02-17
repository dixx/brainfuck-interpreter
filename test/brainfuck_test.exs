defmodule BrainfuckTest do
  use ExUnit.Case
  doctest Brainfuck

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
    precondition = "++++++++++++++++++++++++++++++++++++++++++"
    assert Brainfuck.run(precondition <> "---") == {0, [39], ""}
  end

  test "values clamp between 0 and 255" do
    assert Brainfuck.run(
    "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    <> "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    <> "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    ) == {0, [0], ""}
    assert Brainfuck.run("-") == {0, [255], ""}
  end

  test "> increments the data pointer" do
    assert Brainfuck.run(">>>") == {3, [0, 0, 0, 0], ""}
  end

  test "< decrements the data pointer" do
    assert Brainfuck.run("<<<") == {0, [0, 0, 0, 0], ""}
  end

  test ". output the value at the data pointer as byte" do
    precondition = "++++++++++++++++++++++++++++++++++++++++++"
    assert Brainfuck.run(precondition <> ".") == {0, [42], "*"}
  end

  @tag :skip
  test ", read a byte into the cell at pointer location" do
  end

  test "[ if the current cell value is zero, jump to the next matching ]" do
    assert Brainfuck.run("[+++]+") == {0, [1], ""}
  end

  test "[ if the current cell value is not zero, execute loop body" do
    assert Brainfuck.run("+++++[-]+") == {0, [1], ""}
  end

  test "unbalanced loop borders" do
    assert_raise RuntimeError, "unbalanced loop", fn -> Brainfuck.run("[") end
    # assert_raise RuntimeError, "unbalanced loop", fn -> Brainfuck.run("]") end # TODO check if this is really ok!
    assert_raise RuntimeError, "unbalanced loop", fn -> Brainfuck.run("[[[][]]") end
    assert_raise RuntimeError, "unbalanced loop", fn -> Brainfuck.run("[[][[]]") end
    # assert_raise RuntimeError, "unbalanced loop", fn -> Brainfuck.run("[[][]]]") end # TODO check if this is really ok!
  end
end
