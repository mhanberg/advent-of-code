defmodule AdventOfCode2018.Day08Test do
  use ExUnit.Case

  import AdventOfCode2018.Day08

  test "part1" do
    input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

    result =
      part1(input)

    assert result == 138
  end

  test "part2" do
    input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
    result = part2(input)

    assert result == 66
  end
end
