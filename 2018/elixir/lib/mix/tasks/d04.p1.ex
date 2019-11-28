defmodule Mix.Tasks.D04.P1 do
  use Mix.Task

  import AdventOfCode2018.Day04

  @shortdoc "Day 04 Part 1"
  def run(_) do
    input =
      File.stream!("priv/day04/input.txt")
      |> Stream.map(&String.trim/1)

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")
  end
end
