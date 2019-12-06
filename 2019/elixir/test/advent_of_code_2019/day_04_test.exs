defmodule AdventOfCode2019.Day04Test do
  use ExUnit.Case

  import AdventOfCode2019.Day04

  test "part1" do
    input = 256_310..732_736
    result = part1(input)

    assert result
  end

  @tag :skip
  test "part2" do
    input = 256_310..732_736
    result = part2(input)

    assert result
  end
end
