defmodule Mix.Tasks.D06.P1 do
  use Mix.Task

  import AdventOfCode2018.Day06

  @shortdoc "Day 06 Part 1"
  def run(_) do
    input =
      File.stream!("priv/day06/input.txt")
      |> Stream.map(&String.trim/1)

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")
  end
end
