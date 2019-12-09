defmodule AdventOfCode2019.Day09Test do
  use ExUnit.Case

  import AdventOfCode2019.Day09

  test "part1" do
    input = [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
    result = part1(input) |> IO.inspect(charlists: :as_lists) |> Enum.reverse

    assert result == input

    input = [1102, 34_915_192, 34_915_192, 7, 4, 7, 99, 0]
    [result] = part1(input)

    assert String.length(to_string(result)) == 16

    input = [104, 1_125_899_906_842_624, 99]
    [result] = part1(input)

    assert result == 1_125_899_906_842_624
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
