defmodule Mix.Tasks.D06.P1 do
  use Mix.Task

  import AdventOfCode2019.Day06

  @shortdoc "Day 06 Part 1"
  def run(args) do
    input = Utils.input_to_list("day_06.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
