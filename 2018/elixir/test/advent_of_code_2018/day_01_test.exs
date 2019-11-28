defmodule AdventOfCode2018.Day01Test do
  use ExUnit.Case

  import AdventOfCode2018.Day01

  test "part1" do
    input = ~w[1 -2 3 1]
    result = part1(input)

    assert result == 3
  end

  test "part2" do
    input = ~w[7 7 -2 -7 -4]
    result = part2(input)

    assert result == 14
  end
end
