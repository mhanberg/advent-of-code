defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03
  alias AdventOfCode.Day03.Grid
  alias AdventOfCode.Day03.Grid.Cell

  test "part1" do
    result =
      Utils.read!("day3_example_input.txt")
      |> part1()

    assert result == 7
  end

  @tag :skip
  test "part2" do
    result =
      Utils.read!("day3_example_input.txt")
      |> part2()

    assert result = 336
  end
end
