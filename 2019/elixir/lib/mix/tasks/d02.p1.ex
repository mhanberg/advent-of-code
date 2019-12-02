defmodule Mix.Tasks.D02.P1 do
  use Mix.Task

  import AdventOfCode2019.Day02

  @shortdoc "Day 02 Part 1"
  def run(args) do
    input = Utils.input_split_by("day_02.txt", ",", &String.to_integer/1)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() |> Map.get(0) end}),
      else:
        input
        |> part1()
        |> Map.get(0)
        |> IO.inspect(label: "Part 1 Results")
  end
end
