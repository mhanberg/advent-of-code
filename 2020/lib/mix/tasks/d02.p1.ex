defmodule Mix.Tasks.D02.P1 do
  use Mix.Task

  import AdventOfCode.Day02

  @shortdoc "Day 02 Part 1"
  def run(args) do
    input = Utils.input_split_by("day2_input.txt", "\n", fn line ->
      spec = Regex.named_captures(~r{(?<range>.*) (?<letter>\w): (?<password>.*)}, line)
      range = spec["range"] |> String.replace("-", "..") |> Code.eval_string() |> elem(0)

      %{spec | "range" => range}
    end)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
