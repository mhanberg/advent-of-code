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

    {{x, y}, _, polar_coords} =
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

    cycle = Stream.cycle((90..360 |> Enum.to_list) ++ (0..89 |> Enum.to_list))

    {back, front} =
      polar_coords
      |> Enum.sort_by(
        fn {_, distance, degrees} -> [degrees, distance] end,
        fn [de, di], [de2, di2] ->
          if de == de2 do
            di <= di2
          else
            de >= de2
          end
        end
      )
      |> Enum.split_while(fn {_, _, degree} -> degree > 90 end)

    # :queue.from_list(front ++ back)
    # |> destroy_asteroids(nil, 0)
  end

  # defp destroy_asteroids(_asteroids, last_kill 200) do
  #   last_kill
  # end

  # defp destroy_asteroids(asteroids, last_kill, count) do
  #   {{:value, asteroid}, asteroids} = :queue.out(asteroids)
  # end

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

  defp cart_to_polar_degrees({x, y}), do: (:math.atan2(y, x) * 360 / 2 / :math.pi()) + 180

  defp distance_from_center({x, y}),
    do: :math.sqrt(:math.pow(x, 2) + :math.pow(y, 2))
end
