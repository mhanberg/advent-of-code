defmodule Mix.Tasks.D13.P2 do
  use Mix.Task

  import AdventOfCode2019.Day13

  @shortdoc "Day 13 Part 2"
  def run(args) do
    input = Utils.input_split_by("day_13.txt", ",", &String.to_integer/1) |> List.replace_at(0, 2)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
