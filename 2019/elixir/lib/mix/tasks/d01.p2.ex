defmodule Mix.Tasks.D01.P2 do
  use Mix.Task

  import AdventOfCode2019.Day01

  @shortdoc "Day 01 Part 2"
  def run(args) do
    input =
      File.stream!("priv/day_01.txt")
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.to_integer/1)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
