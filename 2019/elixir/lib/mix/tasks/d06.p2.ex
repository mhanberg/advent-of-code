defmodule Mix.Tasks.D06.P2 do
  use Mix.Task

  import AdventOfCode2019.Day06

  @shortdoc "Day 06 Part 2"
  def run(args) do
    input = Utils.input_to_list("day_06.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
