defmodule Mix.Tasks.D03.P2 do
  use Mix.Task

  import AdventOfCode2018.Day03

  @shortdoc "Day 03 Part 2"
  def run(_) do
    input =
      File.stream!("priv/day03/input.txt")
      |> Stream.map(&String.trim/1)

    input
    |> part2()
    |> IO.inspect(label: "Part 2 Results")

    Benchee.run(%{
      "part2" => fn -> part2(input) end
    })
  end
end
