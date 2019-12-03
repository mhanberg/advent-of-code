defmodule AdventOfCode2019.Day03Test do
  use ExUnit.Case

  import AdventOfCode2019.Day03

  test "part1" do
    input = """
    R75,D30,R83,U83,L12,D49,R71,U7,L72
    U62,R66,U55,R34,D71,R55,D58,R83
    """
    result = part1(input)

    assert result == 159
  end

  test "part2" do
    input = """
    R8,U5,L5,D3
    U7,R6,D4,L4
    """
    result = part2(input)

    assert result == 30

    input = """
    R75,D30,R83,U83,L12,D49,R71,U7,L72
    U62,R66,U55,R34,D71,R55,D58,R83
    """
    result = part2(input)

    assert result == 610

    input = """
    R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
    U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
    """
    result = part2(input)

    assert result == 410
  end
end
