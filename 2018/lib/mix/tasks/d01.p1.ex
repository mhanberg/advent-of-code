defmodule Mix.Tasks.D01.P1 do
  use Mix.Task

  import AdventOfCode2018.Day01

  @shortdoc "Day 01 Part 1"
  def run(_) do
    input = File.stream!(Path.expand("priv/day01/input.txt", File.cwd!))

    input |> part1() |> IO.inspect(label: "Part 1 result")

    Benchee.run(%{part_1: fn -> input |> part1() end})
  end
end
