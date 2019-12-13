defmodule AdventOfCode2019.Day12Test do
  use ExUnit.Case

  import AdventOfCode2019.Day12

  test "part1" do
    input = """
    <x=-1, y=0, z=2>
    <x=2, y=-10, z=-7>
    <x=4, y=-8, z=8>
    <x=3, y=5, z=-1>
    """

    result = part1(input, 10)

    assert result == 179

    input = """
    <x=-8, y=-10, z=0>
    <x=5, y=5, z=10>
    <x=2, y=-7, z=3>
    <x=9, y=-8, z=-3>
    """

    result = part1(input, 100)

    assert result == 1940
  end

  @tag timeout: :infinity
  test "part2 easy" do
    input = """
    <x=-1, y=0, z=2>
    <x=2, y=-10, z=-7>
    <x=4, y=-8, z=8>
    <x=3, y=5, z=-1>
    """

    result =
      part2(
        [{-1, 0}, {2, 0}, {4, 0}, {3, 0}],
        [{0, 0}, {-10, 0}, {-8, 0}, {5, 0}],
        [{2, 0}, {7, 0}, {8, 0}, {-1, 0}]
      )

    assert result == 2772
  end

  @tag timeout: :infinity
  test "part2 hard" do
    input = """
    <x=-8, y=-10, z=0>
    <x=5, y=5, z=10>
    <x=2, y=-7, z=3>
    <x=9, y=-8, z=-3>
    """

    result =
      part2(
        [{-8, 0}, {5, 0}, {2, 0}, {9, 0}],
        [{-10, 0}, {5, 0}, {-7, 0}, {-8, 0}],
        [{0, 0}, {10, 0}, {3, 0}, {3, 0}]
      )

    assert result == 4_686_774_924
  end
end
