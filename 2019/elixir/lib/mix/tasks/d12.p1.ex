defmodule Mix.Tasks.D12.P1 do
  use Mix.Task

  import AdventOfCode2019.Day12

  @shortdoc "Day 12 Part 1"
  def run(args) do
    input = """
    <x=-8, y=-18, z=6>
    <x=-11, y=-14, z=4>
    <x=8, y=-3, z=-10>
    <x=-2, y=-16, z=1>
    """

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1(1000) end}),
      else:
        input
        |> part1(1000)
        |> IO.inspect(label: "Part 1 Results")
  end
end
