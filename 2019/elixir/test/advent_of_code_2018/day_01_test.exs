defmodule AdventOfCode2019.Day01Test do
  use ExUnit.Case

  import AdventOfCode2019.Day01

  test "part1" do
    input = [12, 14, 1969, 100_756]
    result = part1(input)

    assert result == 2 + 2 + 654 + 33583
  end

  test "part2" do
    input = [14, 1969, 100_756]
    result = part2(input)

    assert result == 2 + 966 + 50346
  end
end
