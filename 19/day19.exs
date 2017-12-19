defmodule Day19 do
  def move(:down, {x, y}, graph, acc) do
    case graph[{x, y + 1}] do
      "+" -> if graph[{x+1, y+1}] != nil, do: move(:right, {x + 1, y + 1}, graph, acc), else: move(:left, {x - 1, y + 1}, graph, acc)
      nil -> acc
      letter when letter != "|" and letter != "-" and letter != "+" -> move(:down, {x, y + 1}, graph, acc ++ [letter])
      _ -> move(:down, {x, y + 1}, graph, acc)
    end
  end
  def move(:up, {x, y}, graph, acc) do
    case graph[{x, y - 1}] do
      "+" -> if graph[{x+1, y-1}] != nil, do: move(:right, {x + 1, y - 1}, graph, acc), else: move(:left, {x - 1, y - 1}, graph, acc)
      nil -> acc
      letter when letter != "|" and letter != "-" and letter != "+" -> move(:up, {x, y - 1}, graph, acc ++ [letter])
      _ -> move(:up, {x, y - 1}, graph, acc)
    end
  end
  def move(:left, {x, y}, graph, acc) do
    case graph[{x - 1, y}] do
      "+" -> if graph[{x-1, y+1}] != nil, do: move(:down, {x - 1, y + 1}, graph, acc), else: move(:up, {x - 1, y - 1}, graph, acc)
      nil -> acc
      letter when letter != "|" and letter != "-" and letter != "+" -> move(:left, {x - 1, y}, graph, acc ++ [letter])
      _ -> move(:left, {x - 1, y}, graph, acc)
    end
  end
  def move(:right, {x, y}, graph, acc) do
    case graph[{x + 1, y}] do
      "+" -> if graph[{x+1, y+1}] != nil, do: move(:down, {x + 1, y + 1}, graph, acc), else: move(:up, {x + 1, y - 1}, graph, acc)
      nil -> acc
      letter when letter != "|" and letter != "-" and letter != "+" -> move(:right, {x + 1, y}, graph, acc ++ [letter])
      _ -> move(:right, {x + 1, y}, graph, acc)
    end
  end
end

input =
  File.read!("day19_input.txt")
  |> String.split("\n", trim: true)
  |> Enum.with_index
  |> Enum.reduce(%{}, fn ({row, y}, acc) ->
    row
    |> String.graphemes
    |> Enum.with_index
    |> Enum.reduce(acc, fn({cell, x}, acc2) ->
      case cell do
        " " -> acc2
        _ -> Map.put(acc2, {x, y}, cell)
      end
    end)
  end)

Day19.move(:down, {131, 0}, input, []) |> Enum.join |> IO.inspect

# IO.inspect input[{ 131, 0 }]
