defmodule Mix.Tasks.D03.P1 do
  use Mix.Task

  import AdventOfCode2018.Day03

  @shortdoc "Day 03 Part 1"
  def run(_) do
    input =
      File.stream!("priv/day03/input.txt")
      |> Stream.map(&String.trim/1)

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")

    Benchee.run(%{
      "part1" => fn -> part1(input) end
    })
  end
end
