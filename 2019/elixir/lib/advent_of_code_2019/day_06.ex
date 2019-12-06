defmodule AdventOfCode2019.Day06 do
  alias __MODULE__.Node

  def part1(args) do
    args
    |> Stream.map(&String.split(&1, ")", trim: true))
    |> Enum.reduce(%{}, fn [center, orbit], map ->
      Map.update(map, center, [orbit], &[orbit | &1])
    end)
    |> count("COM", 1)
  end

  def count(map, center, depth) do
    if map[center] do
      orbiters = map[center]
      this_count = depth * Enum.count(orbiters)

      orbiters_count =
        for orbiter <- orbiters, reduce: 0 do
          c ->
            c + count(map, orbiter, depth + 1)
        end

      this_count + orbiters_count
    else
      0
    end
  end

  def part2(args) do
    args
    |> Stream.map(&String.split(&1, ")", trim: true))
    |> Enum.reduce(%{}, fn [center, orbit], map ->
      map
      |> Map.update(center, [orbit], &[orbit | &1])
      |> Map.update(orbit, [center], &[center | &1])
    end)
    |> Enum.reduce(%{}, fn {name, neighbors}, map ->
      Map.put(
        map,
        name,
        Node.new(
          name: name,
          neighbors: neighbors,
          distance: if(name == "YOU", do: -2, else: :infinity)
        )
      )
    end)
    |> find_shortest_path("YOU")
    |> Map.fetch!("SAN")
    |> Map.fetch!(:distance)
  end

  def find_shortest_path(graph, start) do
    initial_node = graph[start].neighbors |> List.first()

    calculate_distance(graph[initial_node], graph[start], graph)
  end

  def calculate_distance(current_node, previous_node, graph) do
    graph =
      put_in(
        graph,
        [current_node.name],
        struct(graph[current_node.name], distance: previous_node.distance + 1, unvisited?: false)
      )

    graph[current_node.name].neighbors
    |> Stream.map(&graph[&1])
    |> Stream.filter(&Node.unvisited?/1)
    |> Enum.reduce(graph, fn neighbor, graph ->
      calculate_distance(neighbor, graph[current_node.name], graph)
    end)
  end

  defmodule Node do
    defstruct [:name, :distance, :neighbors, unvisited?: true]
    def new(opts), do: struct(%__MODULE__{}, opts)

    def unvisited?(node), do: node.unvisited?
  end
end
