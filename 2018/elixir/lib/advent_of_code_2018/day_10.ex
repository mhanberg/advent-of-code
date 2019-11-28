defmodule AdventOfCode2018.Day10 do
  def part1(args) do
    coords =
      args
      |> Stream.map(fn line ->
        regex =
          ~r/position=<(?<x>-?\s?\d+), (?<y>-?\s?\d+)> velocity=<(?<vx>-?\s?\d+), (?<vy>-?\s?\d+)>/

        captures = Regex.named_captures(regex, line)

        log_to_integer(captures["x"], captures["y"], captures["vx"], captures["vy"])
      end)

    map =
      Enum.reduce(coords, Map.new(), fn {coord, vel}, map ->
        Map.update(map, coord, [vel], fn v -> [vel | v] end)
      end)

    map
    |> move(0, 10_000_000_000)
  end

  defp move(_, part2, :abort), do: part2

  defp move(map, part2, num) do
    tri = 10_000_000_000 - num
    IO.inspect(tri, label: "step")

    multiplier =
      if tri < 210 do
        50
      else
        1
      end

    unless tri > 267 do
      new =
        Enum.reduce(map, map, fn {{x, y} = key, vels}, acc ->
          Stream.map(vels, fn {vx, vy} -> {x + vx * multiplier, y + vy * multiplier} end)
          |> Stream.zip(vels)
          |> Enum.reduce(acc, fn {new_pos, vel}, acc2 ->
            acc2 =
              Map.update(acc2, new_pos, [vel], fn v -> [vel | v] end)
              |> Map.update!(key, fn v -> List.delete(v, vel) end)

            if acc2[key] == [] do
              Map.delete(acc2, key)
            else
              acc2
            end
          end)
        end)

      new
      |> print()
      |> move(part2 + multiplier, num - 1)
    else
      move(nil, part2, :abort)
    end
  end

  defp log_to_integer(x, y, vx, vy) do
    x = String.trim(x)
    y = String.trim(y)
    vx = String.trim(vx)
    vy = String.trim(vy)

    {{String.to_integer(x), String.to_integer(y)}, {String.to_integer(vx), String.to_integer(vy)}}
  end

  defp print(map) do
    {{{min_x, _}, _}, {{max_x, _}, _}} = Enum.min_max_by(map, fn {{x, _}, _v} -> x end)
    {{{_, min_y}, _}, {{_, max_y}, _}} = Enum.min_max_by(map, fn {{_, y}, _v} -> y end)

    IO.inspect((max_x - min_x + 1) * (max_y - min_y + 1), label: "area")

    if max_x - min_x <= 80 do
      Enum.each(min_y..max_y, fn y ->
        Enum.map(min_x..max_x, fn x ->
          case map[{x, y}] do
            nil ->
              "."

            [] ->
              "."

            _vel ->
              "#"
          end
        end)
        |> Enum.join()
        |> IO.inspect()
      end)

      IO.puts("")
    end

    map
  end

  def part2(_), do: nil
end
