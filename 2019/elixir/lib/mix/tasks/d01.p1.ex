defmodule Mix.Tasks.D01.P1 do
  use Mix.Task

  import AdventOfCode2019.Day01

  @shortdoc "Day 01 Part 1"
  def run(args) do
    input =
      File.stream!("priv/day_01.txt")
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.to_integer/1)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
