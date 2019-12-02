defmodule AdventOfCode2019.Day02Test do
  use ExUnit.Case

  import AdventOfCode2019.Day02

  test "part1" do
    input = Utils.input_split_by("day_02_example.txt", ",", &String.to_integer/1)
    result = part1(input)

    assert result ==
             [2, 3, 0, 6, 99]
             |> Enum.with_index()
             |> Enum.reduce(Map.new(), fn {opcode, i}, map ->
               Map.put(map, i, opcode)
             end)
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
