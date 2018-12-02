defmodule Mix.Tasks.D01.P2 do
  use Mix.Task

  import AdventOfCode2018.Day01

  @shortdoc "Day 01 Part 2"
  def run(_) do
    input = File.stream!(Path.expand("priv/day01/input.txt", File.cwd!))

    input |> part2() |> IO.inspect(label: "Part 2 result")

    Benchee.run(%{ part_2: fn -> input |> part2() end })
  end
end
