defmodule AdventOfCode2018.Day05Test do
  use ExUnit.Case

  import AdventOfCode2018.Day05

  test "part1" do
    input = "dabAcCaCBAcCcaDA"

    result = part1(input)

    assert result == 10
  end

  test "part2" do
    input = "dabAcCaCBAcCcaDA"
    result = part2(input)

    assert result == 4
  end
end
