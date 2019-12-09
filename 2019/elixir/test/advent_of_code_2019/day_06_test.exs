defmodule AdventOfCode2019.Day06Test do
  use ExUnit.Case

  import AdventOfCode2019.Day06

  test "part1" do
    input = Utils.input_to_list("day_06_example.txt")

    result = part1(input)

    assert result == 42
  end

  test "part2" do
    input = Utils.input_to_list("day_06_example-2.txt")
    result = part2(input)

    assert result == 4
  end
end
