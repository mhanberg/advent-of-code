defmodule AdventOfCode2018.Day02Test do
  use ExUnit.Case

  import AdventOfCode2018.Day02

  test "part1" do
    input = ~w{
      abcdef
      bababc
      abbcde
      abcccd
      aabcdd
      abcdee
      ababab
    }

    result = part1(input)

    assert result == 12
  end

  test "part2" do
    input = ~w{
      abcde
      fghij
      klmno
      pqrst
      fguij
      axcye
      wvxyz
    }
    result = part2(input)

    assert result == "fgij"
  end
end
