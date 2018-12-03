defmodule AdventOfCode2018.Day02 do
  def part1(args) do
    {two, three} =
      args
      |> Stream.map(fn id ->
        ids = String.split(id, "", trim: true)

        ids
        |> Enum.group_by(fn id ->
          ids
          |> Enum.count(fn x -> id == x end)
        end)
      end)
      |> Enum.reduce({0, 0}, fn x, {two, three} ->
        two = two + ((x[2] && 1) || 0)
        three = three + ((x[3] && 1) || 0)

        {two, three}
      end)

    two * three
  end

  def part2(args) do
    args
    |> Stream.map(fn id ->
      args
      |> Stream.reject(fn x -> x == id end)
      |> Stream.map(fn x -> String.myers_difference(id, x) end)
      |> Stream.filter(fn x -> Keyword.has_key?(x, :eq) end)
      |> Stream.filter(fn x -> Enum.count(x) == 4 end)
      |> Enum.to_list()
      |> List.flatten()
    end)
    |> Stream.reject(fn x -> Enum.empty?(x) end)
    |> Enum.to_list()
    |> List.first()
    |> Keyword.get_values(:eq)
    |> Enum.join()
  end
end
