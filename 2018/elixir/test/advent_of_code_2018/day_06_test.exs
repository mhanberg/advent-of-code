defmodule AdventOfCode2018.Day06Test do
  use ExUnit.Case

  import AdventOfCode2018.Day06

  test "part1" do
    input =
      """
      1, 1
      1, 6
      8, 3
      3, 4
      5, 5
      8, 9
      """
      |> String.split("\n", trim: true)

    result = part1(input)

    assert result == 17
  end

  test "part2" do
    input =
      """
      1, 1
      1, 6
      8, 3
      3, 4
      5, 5
      8, 9
      """
      |> String.split("\n", trim: true)

    result = part2(input, 32)

    assert result == 16
  end
end
