defmodule Mix.Tasks.D08.P1 do
  use Mix.Task

  import AdventOfCode2019.Day08

  @shortdoc "Day 08 Part 1"
  def run(args) do
    input = {Utils.read!("day_08.txt") |> String.trim() , 25, 6}

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
