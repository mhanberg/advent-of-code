defmodule AdventOfCode2018.Day06 do
  def part1(args) do
    coords =
      args
      |> Stream.map(fn x -> String.split(x, ", ", trim: true) end)
      |> Stream.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)

    {max_x, _} =
      coords
      |> Enum.max_by(fn {x, _y} -> x end)

    {_, max_y} =
      coords
      |> Enum.max_by(fn {_x, y} -> y end)

    closest_destinations =
      for x <- 0..max_x, y <- 0..max_y, into: [] do
        {x, y}
      end
      |> Stream.map(fn {x, y} ->
        {{x, y}, single_closest_or_nil(coords, x, y)}
      end)
      |> Enum.to_list()

    counts =
      coords
      |> Enum.group_by(fn x -> x end, fn x ->
        {
          Enum.count(closest_destinations, fn {_location, destination} -> destination == x end),
          Enum.any?(closest_destinations, fn pair ->
            case pair do
              {{_, 0}, ^x} -> true
              {{_, ^max_y}, ^x} -> true
              {{0, _}, ^x} -> true
              {{^max_x, _}, ^x} -> true
              _ -> false
            end
          end)
        }
      end)

    counts
    |> Enum.reduce(counts, fn {k, [v]}, acc -> Map.put(acc, k, v) end)
    |> Enum.filter(fn {_k, {_, edge?}} -> edge? == false end)
    |> Enum.max_by(fn {_, {area, _}} -> area end)
    |> elem(1)
    |> elem(0)
  end

  def single_closest_or_nil(coords, x, y) do
    [{shortest_dist, dist1}, {_, dist2} | _rest] =
      Enum.map(coords, fn {xp, yp} -> {{xp, yp}, abs(x - xp) + abs(y - yp)} end)
      |> Enum.sort_by(fn {_, dist} -> dist end)

    if dist1 == dist2 do
      nil
    else
      shortest_dist
    end
  end

  def part2(args, range) do
    coords =
      args
      |> Stream.map(fn x -> String.split(x, ", ", trim: true) end)
      |> Stream.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)

    {max_x, _} =
      coords
      |> Enum.max_by(fn {x, _y} -> x end)

    {_, max_y} =
      coords
      |> Enum.max_by(fn {_x, y} -> y end)

    for x <- 0..max_x, y <- 0..max_y, into: [] do
      {x, y}
    end
    |> Stream.map(fn {x, y} ->
      {{x, y}, Enum.map(coords, fn {xp, yp} -> abs(x - xp) + abs(y - yp) end) |> Enum.sum()}
    end)
    |> Stream.filter(fn {_, distance} -> distance < range end)
    |> Enum.count()
  end
end
