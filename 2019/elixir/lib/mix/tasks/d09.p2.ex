defmodule Mix.Tasks.D09.P2 do
  use Mix.Task

  import AdventOfCode2019.Day09

  @shortdoc "Day 09 Part 2"
  def run(args) do
    input = Utils.input_split_by("day_09.txt", ",", &String.to_integer/1)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
