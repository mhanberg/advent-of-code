defmodule Mix.Tasks.D11.P1 do
  use Mix.Task

  import AdventOfCode2019.Day11

  @shortdoc "Day 11 Part 1"
  def run(args) do
    input = Utils.input_split_by("day_11.txt", ",", &String.to_integer/1)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
