defmodule AdventOfCode2018.Day02 do
  def part1(args) do
    {two, three} =
      args
      |> Enum.map(fn id ->
        ids = id
        |> String.split("")
        |> Enum.reject(fn x -> x == "" end)
        ids
        |> Enum.group_by(fn id ->
          ids
          |> Enum.count(fn x -> id == x end)
        end)
      end)
      |> Enum.reduce({0, 0}, fn x, {two, three} ->
        two = two + (x[2] && 1 || 0) 
        three = three + (x[3] && 1 || 0)

        {two, three}
      end)

    two * three
  end

  def part2(args) do
    args
    |> Enum.map(fn id ->
      args
      |> Enum.reject(fn x -> x == id end)
      |> Enum.map(fn x -> String.myers_difference(id, x) end)
      |> Enum.filter(fn x -> Keyword.has_key?(x, :eq) end)
      |> Enum.filter(fn x -> Enum.count(x) == 4 end)
      |> List.flatten
    end)
    |> Enum.reject(fn x -> Enum.empty? x end)
    |> List.first
    |> Keyword.get_values(:eq)
    |> Enum.join
  end
end
