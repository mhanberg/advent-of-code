defmodule AdventOfCode2019.Day03 do
  def part1(args) do
    [%{trail: wire1}, %{trail: wire2}] = gen_trails(args)

    intersections = get_intersections(wire1, wire2)

    for intersection <- intersections do
      manhattan_distance({0, 0}, intersection)
    end
    |> Enum.min()
  end

  def part2(args) do
    [%{trail: wire1}, %{trail: wire2}] = gen_trails(args)

    get_intersections(wire1, wire2)
    |> Enum.map(fn intersection ->
      get_step_count(wire1, intersection) + get_step_count(wire2, intersection)
    end)
    |> Enum.min()
  end

  defp get_step_count(wire, intersection) do
    wire
    |> Enum.reverse()
    |> Enum.find_index(fn step -> step == intersection end)
    |> Kernel.+(1)
  end

  def get_intersections(wire1, wire2) do
    MapSet.intersection(MapSet.new(wire1), MapSet.new(wire2))
    |> MapSet.delete({0, 0})
  end

  defp gen_trails(args) do
    args
    |> parse_args
    |> Enum.map(fn wire ->
      Enum.reduce(wire, %{current: {0, 0}, trail: []}, fn ins, map ->
        move(ins, map)
      end)
    end)
  end

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp move({"R", x}, map) do
    map
    |> Map.update!(:current, fn {cx, cy} -> {cx + x, cy} end)
    |> put_trail
  end

  defp move({"L", x}, map) do
    map
    |> Map.update!(:current, fn {cx, cy} -> {cx - x, cy} end)
    |> put_trail
  end

  defp move({"U", y}, map) do
    map
    |> Map.update!(:current, fn {cx, cy} -> {cx, cy + y} end)
    |> put_trail
  end

  defp move({"D", y}, map) do
    map
    |> Map.update!(:current, fn {cx, cy} -> {cx, cy - y} end)
    |> put_trail
  end

  def put_trail(map) do
    Map.update!(map, :trail, &update_trail(map, &1))
  end

  defp update_trail(%{current: {cx, cy}}, trail) do
    {tx, ty} = if [] == trail, do: {0, 0}, else: List.first(trail)

    [_ | blazed_trail] =
      if cx == tx do
        for ny <- 0..(cy - ty), do: {cx, ny + ty}
      else
        for nx <- 0..(cx - tx), do: {nx + tx, cy}
      end

    Enum.reverse(blazed_trail) ++ trail
  end

  defp parse_args(args) do
    args
    |> String.split()
    |> Stream.map(fn wire ->
      wire
      |> String.split(",")
      |> Enum.map(&String.split_at(&1, 1))
      |> Enum.map(fn {ins, dist} -> {ins, String.to_integer(dist)} end)
    end)
  end
end
