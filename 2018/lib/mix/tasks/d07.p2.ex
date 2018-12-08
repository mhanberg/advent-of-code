defmodule Mix.Tasks.D07.P2 do
  use Mix.Task

  import AdventOfCode2018.Day07

  @shortdoc "Day 07 Part 2"
  def run(_) do
    IO.puts("Please run using the environment variables PENALTY=60 WORKERS=5")

    input =
      File.stream!("priv/day07/input.txt")
      |> Stream.map(&String.trim/1)

    input
    |> part2()
    |> IO.inspect(label: "Part 2 Results")
  end
end
