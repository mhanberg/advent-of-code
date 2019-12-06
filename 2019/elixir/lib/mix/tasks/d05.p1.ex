defmodule Mix.Tasks.D05.P1 do
  use Mix.Task

  import AdventOfCode2019.Day05

  @shortdoc "Day 05 Part 1"
  def run(args) do
    input = Utils.input_split_by("day_05.txt", ",", &String.to_integer/1)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1(1) end}),
      else:
        input
        |> part1(1)
        |> IO.inspect(label: "Part 1 Results")
  end
end
