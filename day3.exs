defmodule Day3 do
  @input 368078

  def n(x) when x > 0, do: n(x - 1) + x
  def n(_x), do: 0

  def first(x), do: last(x - 1) + 1

  def last(x), do: 8 * n(x) + 1

  def dist({x, y}), do: abs(x) + abs(y)

  def coordinates(coord, distance, side_length) do
    move(:up, coord, distance, side_length)
  end

  def move(:up, {x, y}, distance, side_length) when distance > side_length do
    c = {x, y + side_length}
    move(:left, c, distance - side_length, side_length)
  end

  def move(:up, {x, y}, distance, _side_length) do
    {x, y + distance}
  end

  def move(:left, {x, y}, distance, side_length) when distance > side_length do
    c = {x - side_length, y}
    move(:down, c, distance - side_length, side_length)
  end

  def move(:left, {x, y}, distance, _side_length) do
    {x - distance, y}
  end

  def move(:down, {x, y}, distance, side_length) when distance > side_length do
    c = {x, y - side_length}
    move(:right, c, distance - side_length, side_length)
  end

  def move(:down, {x, y}, distance, _side_length) do
    {x, y - distance}
  end

  def move(:right, {x, y}, distance, side_length) when distance > side_length do
    {x + side_length, y}
  end

  def move(:right, {x, y}, distance, _side_length) do
    {x + distance, y}
  end

  def part1(x) do
    case last(x) do
      l when l < @input -> part1(x + 1)
      _ -> coordinates({x, -x}, @input - first(x) + 1, x * 2) |> dist
    end
  end
end

Day3.part1(1)
|> IO.inspect
