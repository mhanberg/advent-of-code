defmodule Mix.Tasks.D08.P2 do
  use Mix.Task

  import AdventOfCode2019.Day08

  @shortdoc "Day 08 Part 2"
  def run(args) do
    input = {Utils.read!("day_08.txt") |> String.trim() , 25, 6}

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
