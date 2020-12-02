defmodule AdventOfCode.Day02 do
  def part1(args) do
    count(args, fn spec ->
      spec["password"]
      |> String.graphemes()
      |> Enum.count(&(&1 == spec["letter"]))
      |> Kernel.in(spec["range"])
    end)
  end

  def part2(args) do
    count(args, fn spec ->
      :erlang.xor(
        char_in_position?(spec["letter"], spec["pos1"], spec["password"]),
        char_in_position?(spec["letter"], spec["pos2"], spec["password"])
      )
    end)
  end

  defp count(args, filter) do
    for spec <- args, filter.(spec), reduce: 0 do
      count -> count + 1
    end
  end

  defp char_in_position?(char, pos, password) do
    String.at(password, pos - 1) == char
  end
end
