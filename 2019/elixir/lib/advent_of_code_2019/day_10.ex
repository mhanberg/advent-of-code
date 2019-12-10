defmodule AdventOfCode2019.Day10 do
  def part1(args) do
    coords = parse_asteroid_map(args)

    coords
    |> Enum.map(fn {x, y} ->
      (coords -- [{x, y}])
      |> map_to_relative_polar_coords({x, y})
      |> Enum.uniq_by(fn {_, _, degrees} -> degrees end)
      |> Enum.count()
    end)
    |> Enum.max()
  end

  def part2(args) do
    coords = parse_asteroid_map(args)

    {_, _, polar_coords} =
      coords
      |> Enum.map(fn {x, y} ->
        polar_coords =
          (coords -- [{x, y}])
          |> map_to_relative_polar_coords({x, y})

        {{x, y},
         polar_coords
         |> Enum.uniq_by(fn {_, _, degrees} -> degrees end)
         |> Enum.count(), polar_coords}
      end)
      |> Enum.max_by(fn {_, count, _} -> count end)

    {back, front} =
      polar_coords
      |> Enum.sort_by(fn {_, distance, degrees} -> [degrees, distance] end)
      |> Enum.split_while(fn {_, _, degree} -> degree < 90 end)

    list = front ++ back

    {killx, killy} =
      list
      |> :queue.from_list()
      |> destroy_asteroids({nil, nil, nil}, 0)

    (killx * 100) + killy
  end

  defp destroy_asteroids(_asteroids, {coord, _, _}, 200) do
    coord
  end

  defp destroy_asteroids(asteroids, {_, _, last_kill_angle} = last_kill, count) do
    {{:value, {_, _, current_target_angle} = current_target}, asteroids} = :queue.out(asteroids)

    if current_target_angle == last_kill_angle do
      destroy_asteroids(:queue.in(current_target, asteroids), last_kill, count)
    else
      destroy_asteroids(asteroids, current_target, count + 1)
    end
  end

  defp parse_asteroid_map(args),
    do:
      args
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, col_idx} ->
        String.split(row, "", trim: true)
        |> Enum.with_index()
        |> Enum.map(fn {asteroid, row_idx} ->
          if(asteroid == "#", do: {row_idx, col_idx})
        end)
      end)
      |> Enum.filter(& &1)

  defp map_to_relative_polar_coords(coords, {base_x, base_y}),
    do:
      Enum.map(coords, fn {x2, y2} ->
        relative_coords = {x2 - base_x, y2 - base_y}

        {
          {x2, y2},
          distance_from_center(relative_coords),
          cart_to_polar_degrees(relative_coords)
        }
      end)

  defp cart_to_polar_degrees({x, y}), do: :math.atan2(y, x) * 360 / 2 / :math.pi() + 180

  defp distance_from_center({x, y}),
    do: :math.sqrt(:math.pow(x, 2) + :math.pow(y, 2))
end
