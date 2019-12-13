defmodule Mix.Tasks.D12.P2 do
  use Mix.Task

  import AdventOfCode2019.Day12

  @shortdoc "Day 12 Part 2"
  def run(args) do
    if Enum.member?(args, "-b"),
      do:
        Benchee.run(%{
          part_2: fn ->
            part2(
              [{-8, 0}, {-11, 0}, {8, 0}, {-2, 0}],
              [{-18, 0}, {-14, 0}, {-3, 0}, {-16, 0}],
              [{6, 0}, {4, 0}, {-10, 0}, {1, 0}]
            )
          end
        }),
      else:
        part2(
          [{-8, 0}, {-11, 0}, {8, 0}, {-2, 0}],
          [{-18, 0}, {-14, 0}, {-3, 0}, {-16, 0}],
          [{6, 0}, {4, 0}, {-10, 0}, {1, 0}]
        )
        |> IO.inspect(label: "Part 2 Results")
  end
end
