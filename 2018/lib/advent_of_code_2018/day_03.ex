defmodule AdventOfCode2018.Day03 do
  def part1(args) do
    args
    |> Stream.flat_map(fn x -> extract_loc_data(x) |> build_inch_map() end)
    |> Enum.reduce({MapSet.new(), MapSet.new()}, fn {x, y, _}, {contested, safe} ->
      if MapSet.member?(safe, {x, y}) do
        {MapSet.put(contested, {x, y}), safe}
      else
        {contested, MapSet.put(safe, {x, y})}
      end
    end)
    |> elem(0)
    |> MapSet.size()
  end

  def part2(args) do
    {contested, contested_ids, _, safe_ids} =
      args
      |> Stream.flat_map(fn x -> extract_loc_data(x) |> build_inch_map() end)
      |> Enum.reduce(
        {MapSet.new(), MapSet.new(), MapSet.new(), MapSet.new()},
        fn {x, y, _id} = loc, {contested, contested_ids, safe, safe_ids} ->
          anon_loc = {x, y}

          if MapSet.member?(safe, anon_loc) do
            {MapSet.put(contested, anon_loc), MapSet.put(contested_ids, loc), safe, safe_ids}
          else
            {contested, contested_ids, MapSet.put(safe, anon_loc), MapSet.put(safe_ids, loc)}
          end
        end
      )

    beefed_contested_ids =
      safe_ids
      |> Enum.reduce(contested_ids, fn {x, y, _id} = loc, acc ->
        contested
        |> MapSet.member?({x, y})
        |> if do
          MapSet.put(acc, loc)
        else
          acc
        end
      end)

    safe_ids
    |> Stream.map(fn {_, _, id} -> id end)
    |> MapSet.new()
    |> MapSet.difference(
      beefed_contested_ids
      |> Stream.map(fn {_, _, id} -> id end)
      |> MapSet.new()
    )
    |> MapSet.to_list()
    |> List.first()
  end

  defp extract_loc_data(line) do
    Regex.named_captures(
      ~r/#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<width>\d+)x(?<height>\d+)/,
      line
    )
    |> Map.update!("x", &String.to_integer/1)
    |> Map.update!("y", &String.to_integer/1)
    |> Map.update!("width", &String.to_integer/1)
    |> Map.update!("height", &String.to_integer/1)
  end

  defp build_inch_map(location_data) do
    {:ok, ag} = Agent.start(fn -> [] end)

    for x <- location_data["x"]..(location_data["x"] + location_data["width"] - 1),
        y <- location_data["y"]..(location_data["y"] + location_data["height"] - 1) do
      Agent.update(ag, fn claims -> [{x, y, location_data["id"]} | claims] end)
    end

    Agent.get(ag, & &1, 1000)
  end
end
