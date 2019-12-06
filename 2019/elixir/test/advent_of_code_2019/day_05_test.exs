defmodule AdventOfCode2019.Day05Test do
  use ExUnit.Case

  import AdventOfCode2019.Day05

  test "part1" do
    args = [3, 0, 4, 0, 99]
    input = 1
    {_, result} = part1(args, input)

    assert result == [1]

    args = [1002, 4, 3, 4, 33]
    input = 1
    {result, _} = part1(args, input)

    assert result == %{0 => 1002, 1 => 4, 2 => 3, 3 => 4, 4 => 99}
  end

  test "part2" do
    args = [ 3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105, 1, 46, 98, 99 ]
    input = 7

    {_, result} = part2(args, input)

    assert hd(result) == 999

    input = 8

    {_, result} = part2(args, input)

    assert hd(result) == 1000
    input = 9

    {_, result} = part2(args, input)

    assert hd(result) == 1001
  end
end
