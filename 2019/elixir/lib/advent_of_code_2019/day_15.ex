defmodule AdventOfCode2019.Day15 do
  import IO.ANSI
  alias __MODULE__.Droid

  def part1(args) do
    program = Vm.parse(args)

    {:ok, _} = Vm.start_link(:e, program, [], [], self(), self())

    IO.write(clear())

    droid = await(Droid.new())

    Enum.count(droid.path)
  end

  defp await(droid) do
    receive do
      {:add_inputs, [0]} ->
        droid
        |> Droid.log_wall()
        |> await()

      {:add_inputs, [1]} ->
        await(droid)

      {:add_inputs, [2]} ->
        GenServer.stop(:e)

        droid

      {:request_input, pid} ->
        if Droid.new_territory_available?(droid) do
          direction = Droid.get_next_direction(droid)

          droid =
            droid
            |> Droid.move(:explore, direction)

          send(pid, {:add_inputs, [direction]})

          droid
        else
          {droid, direction} =
            droid
            |> Droid.move(:backtrack)

          send(pid, {:add_inputs, [direction]})

          droid
        end
        |> Droid.draw_area()
        |> await()
    end
  end

  def part2(args) do
    program = Vm.parse(args)

    {:ok, _} = Vm.start_link(:e, program, [], [], self(), self())

    IO.write(clear())

    droid = await2(Droid.new())

    droid.area
    |> Map.put(droid.station_location, "O")
    |> oxygenate(0)
  end

  def oxygenate(area, minutes) do
    if Enum.all?(area, fn {_k, v} -> Enum.member?(["#", "O"], v) end) do
      minutes
    else
      area
      |> Enum.filter(fn {_k, v} -> v == "O" end)
      |> Enum.into(Map.new)
      |> Enum.reduce(area, fn {coord, _}, acc_area ->
        coord
        |> get_adjacent_nodes(area)
        |> Enum.reduce(acc_area, fn coord, acc ->
          Map.put(acc, coord, "O")
        end)
      end)
      |> oxygenate(minutes + 1)
    end
  end

  def get_adjacent_nodes({x, y}, area) do
    [
      {area[{x, y + 1}], {x, y + 1}},
      {area[{x, y - 1}], {x, y - 1}},
      {area[{x - 1, y}], {x - 1, y}},
      {area[{x + 1, y}], {x + 1, y}}
    ]
    |> Enum.filter(fn {tile, _} -> tile == "." end)
    |> Enum.map(fn {_, coord} -> coord end)
  end

  defp await2(droid) do
    receive do
      {:add_inputs, [0]} ->
        droid
        |> Droid.log_wall()
        |> await2()

      {:add_inputs, [1]} ->
        await2(droid)

      {:add_inputs, [2]} ->
        struct(droid, station_location: droid.location)
        |> await2()

      {:request_input, pid} ->
        if Droid.new_territory_available?(droid) do
          direction = Droid.get_next_direction(droid)

          droid =
            droid
            |> Droid.move(:explore, direction)

          send(pid, {:add_inputs, [direction]})

          droid
          |> await2()
        else
          case Droid.move(droid, :backtrack) do
            {droid, :end} ->
              GenServer.stop(:e)

              droid
              |> Droid.draw_area()

            {droid, direction} ->
              send(pid, {:add_inputs, [direction]})

              droid
              |> Droid.draw_area()
              |> await2()
          end
        end
    end
  end

  defmodule Droid do
    defstruct area: %{{0, 0} => "."}, location: {0, 0}, path: [], trail: [{0, 0}], walls: [], station_location: nil

    def new, do: %__MODULE__{}

    def new_territory_available?(droid) do
      potential_directions = reject_walls(droid.walls, droid.location)

      Enum.any?(
        potential_directions,
        fn dir ->
          potential_location = calculate_location(dir, droid.location)

          nil == droid.area[potential_location]
        end
      )
    end

    def reject_walls(walls, location) do
      1..4
      |> Enum.reject(fn dir ->
        potential_location = calculate_location(dir, location)

        Enum.member?(walls, potential_location)
      end)
    end

    def reject_traveled(area, location) do
      1..4
      |> Enum.reject(fn dir ->
        potential_location = calculate_location(dir, location)

        area[potential_location] == "."
      end)
    end

    def get_next_direction(%__MODULE__{location: location, walls: walls} = droid) do
      List.first(
        MapSet.intersection(
          MapSet.new(reject_walls(walls, location)),
          MapSet.new(reject_traveled(droid.area, location))
        )
        |> MapSet.to_list()
      )
    end

    def move(droid, :explore, direction) do
      new_location = calculate_location(direction, droid.location)

      struct(
        droid,
        location: new_location,
        area: Map.put(droid.area, new_location, "."),
        path: [direction | droid.path],
        trail: [new_location | droid.trail]
      )
    end

    def move(%__MODULE__{path: [location | path], trail: [_ | trail]} = droid, :backtrack) do
      direction = calculate_opposite_direction(location)
      new_location = calculate_location(direction, droid.location)

      {struct(droid, location: new_location, path: path, trail: trail), direction}
    end

    def move(%__MODULE__{location: {0, 0}} = droid, :backtrack) do
      {droid, :end}
    end

    defp calculate_opposite_direction(1), do: 2
    defp calculate_opposite_direction(2), do: 1
    defp calculate_opposite_direction(3), do: 4
    defp calculate_opposite_direction(4), do: 3

    def log_wall(
          %__MODULE__{area: area, path: [hit | path], trail: [_ | trail], walls: walls} = droid
        ) do
      direction = calculate_opposite_direction(hit)
      new_location = calculate_location(direction, droid.location)

      struct(
        droid,
        location: new_location,
        path: path,
        trail: trail,
        area: Map.put(area, droid.location, "#"),
        walls: [droid.location | walls]
      )
    end

    # north
    def calculate_location(1, {x, y}), do: {x, y + 1}
    # south
    def calculate_location(2, {x, y}), do: {x, y - 1}
    # west
    def calculate_location(3, {x, y}), do: {x - 1, y}
    # east
    def calculate_location(4, {x, y}), do: {x + 1, y}

    def draw_area(%__MODULE__{area: area, location: location} = droid) do
      {min_x, min_y, max_x, max_y} =
        if Enum.empty?(area) do
          {-10, -10, 10, 10}
        else
          {{_, min_y}, {_, max_y}} = Map.keys(area) |> Enum.min_max_by(fn {_, y} -> y end)
          {{min_x, _}, {max_x, _}} = Map.keys(area) |> Enum.min_max_by(fn {x, _} -> x end)

          {min_x, min_y, max_x, max_y}
        end

      IO.write(
        cursor(0, 0) <>
          for y <- min_y..max_y, into: "" do
            "\r" <>
              for x <- min_x..max_x, into: "" do
                cond do
                  {x, y} == {0, 0} ->
                    yellow_background() <> " " <> reset()

                  {x, y} == location ->
                    red_background() <> " " <> reset()

                  Enum.member?(droid.trail, {x, y}) ->
                    cyan_background() <> " " <> reset()

                  droid.area[{x, y}] == "." ->
                    white_background() <> black() <> "." <> reset()

                  true ->
                    area[{x, y}] || " "
                end
              end <> "\n"
          end
      )

      droid
    end
  end
end
