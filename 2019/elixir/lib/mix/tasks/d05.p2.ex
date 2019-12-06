defmodule Mix.Tasks.D05.P2 do
  use Mix.Task

  import AdventOfCode2019.Day05

  @shortdoc "Day 05 Part 2"
  def run(args) do
    input = Utils.input_split_by("day_05.txt", ",", &String.to_integer/1)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2(5) end}),
      else:
        input
        |> part2(5)
        |> IO.inspect(label: "Part 2 Results")
  end
end
