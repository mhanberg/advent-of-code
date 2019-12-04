defmodule Mix.Tasks.D04.P2 do
  use Mix.Task

  import AdventOfCode2019.Day04

  @shortdoc "Day 04 Part 2"
  def run(args) do
    input = 256310..732736

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
