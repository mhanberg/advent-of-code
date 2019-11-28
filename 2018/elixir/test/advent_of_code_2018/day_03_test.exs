defmodule AdventOfCode2018.Day03Test do
  use ExUnit.Case

  import AdventOfCode2018.Day03

  test "part1" do
    input =
      """
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2 
      """
      |> String.split("\n", trim: true)

    result = part1(input)

    assert result == 4
  end

  test "part1 dos" do
    input =
      """
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 4,4: 2x2 
      """
      |> String.split("\n", trim: true)

    result = part1(input)

    assert result == 6
  end

  test "part2" do
    input =
      """
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2 
      """
      |> String.split("\n", trim: true)

    result = part2(input)

    assert result == "3"
  end
end
