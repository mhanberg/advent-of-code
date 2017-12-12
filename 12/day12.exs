defmodule Day12 do
  def solve(m, pos, acc) do
    new_pipes = Enum.reject(m[pos], &(Enum.member?(acc, &1)))
    Enum.reduce(new_pipes, acc ++ new_pipes, &(solve(m, &1, &2)))
  end

  def solve2(m, acc) do
    pos = Map.keys(m) |> Enum.sort |> List.first
    keys_to_drop = solve(m, pos, [])
    m = Map.drop(m, keys_to_drop)
    cond do
      Enum.empty?(m) -> acc + 1
      true -> solve2(m, acc + 1)
    end
  end
end

input = File.read!("day12_input.txt")
|> String.split("\n", trim: true)
|> Enum.reduce(%{}, fn (x, acc) ->
  [k | v] = String.replace(x, "<->", "") |> String.replace(",", "") |> String.split
  Map.put(acc, String.to_integer(k), Enum.map(v, &(String.to_integer(&1))))
end)

# Part 1
input
|> Day12.solve(0, [])
|> length
|> IO.inspect

# Part 2
input
|> Day12.solve2(0)
|> IO.inspect
