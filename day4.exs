defmodule Day4 do
  def part1(x, acc) do
    l = String.split(x)
    case length(l) == length(Enum.uniq(l)) and length(l) > 0 do
      true ->  acc + 1
      _ -> acc
    end
  end

  def part2(x, acc) do
    l = String.split(x) |> Enum.map(fn x -> x |> String.graphemes |> Enum.sort |> Enum.join end)
    case length(l) == length(Enum.uniq(l)) and length(l) > 0 do
      true ->  acc + 1
      _ -> acc
    end
  end
end

# Part 1
File.read!("day4_input.txt")
  |> String.split(~r{\n})
  |> Enum.reduce(0, &Day4.part1/2)
  |> IO.inspect

# Part 2
File.read!("day4_input.txt")
  |> String.split(~r{\n})
  |> Enum.reduce(0, &Day4.part2/2)
  |> IO.inspect
