defmodule Mix.Tasks.D10.P2 do
  use Mix.Task

  import AdventOfCode2019.Day10

  @shortdoc "Day 10 Part 2"
  def run(args) do
    input = Utils.read!("day_10.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
