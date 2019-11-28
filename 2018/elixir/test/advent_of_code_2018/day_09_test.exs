defmodule AdventOfCode2018.Day09Test do
  use ExUnit.Case

  import AdventOfCode2018.Day09

  test "part1" do
    inputs = [{9, 25}, {10, 1618}, {13, 7999}, {17, 1104}, {21, 6111}, {30, 5807}]
    actuals = [32, 8317, 146_373, 2764, 54718, 37305]
    results = Enum.map(inputs, &part1/1)

    assert results == actuals
  end
end
