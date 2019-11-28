defmodule Mix.Tasks.D08.P2 do
  use Mix.Task

  import AdventOfCode2018.Day08

  @shortdoc "Day 08 Part 2"
  def run(_) do
    input = File.read!("priv/day08/input.txt")

    input
    |> part2()
    |> IO.inspect(label: "Part 2 Results")

    Benchee.run(%{
      "part2" => fn -> part2(input) end
    })
  end
end
