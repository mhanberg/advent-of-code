defmodule AdventOfCode2019.Day08Test do
  use ExUnit.Case

  import AdventOfCode2019.Day08

  test "part1" do
    input = {"123456789012", 3, 2}
    result = part1(input)

    assert result == 1
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
