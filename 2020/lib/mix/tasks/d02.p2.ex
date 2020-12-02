defmodule Mix.Tasks.D02.P2 do
  use Mix.Task

  import AdventOfCode.Day02

  @shortdoc "Day 02 Part 2"
  def run(args) do
    input = Utils.input_split_by("day2_input.txt", "\n", fn line ->
      spec = Regex.named_captures(~r{(?<pos1>\d*)-(?<pos2>\d*) (?<letter>\w): (?<password>.*)}, line)

      %{spec | "pos1" => String.to_integer(spec["pos1"]), "pos2" => String.to_integer(spec["pos2"])}
    end)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
