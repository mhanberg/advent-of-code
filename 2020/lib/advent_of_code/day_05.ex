defmodule AdventOfCode.Day05 do
  defmodule Plane do
    @multiplier 8

    defstruct rows: {0, 127}, row: nil, cols: {0, 7}, col: nil, movements: []

    def new(opts \\ []), do: struct(%Plane{}, opts)

    def move(%Plane{movements: []} = plane), do: plane

    def move(%Plane{rows: {front, _back}, movements: ["F" | [next | _] = movements]} = plane)
        when next in ["R", "L"] do
      struct(plane, row: front, movements: movements)
      |> move()
    end

    def move(%Plane{rows: {front, back}, movements: ["F" | movements]} = plane) do
      struct(plane, rows: {front, new_back(front, back)}, movements: movements)
      |> move()
    end

    def move(%Plane{rows: {_front, back}, movements: ["B" | [next | _] = movements]} = plane)
        when next in ["R", "L"] do
      struct(plane, row: back, movements: movements)
      |> move()
    end

    def move(%Plane{rows: {front, back}, movements: ["B" | movements]} = plane) do
      struct(plane, rows: {new_front(front, back), back}, movements: movements)
      |> move()
    end

    def move(%Plane{cols: {front, _back}, movements: ["L" | []]} = plane) do
      struct(plane, col: front, movements: [])
      |> move()
    end

    def move(%Plane{cols: {front, back}, movements: ["L" | movements]} = plane) do
      struct(plane, cols: {front, new_back(front, back)}, movements: movements)
      |> move()
    end

    def move(%Plane{cols: {_front, back}, movements: ["R" | []]} = plane) do
      struct(plane, col: back, movements: [])
      |> move()
    end

    def move(%Plane{cols: {front, back}, movements: ["R" | movements]} = plane) do
      struct(plane, cols: {new_front(front, back), back}, movements: movements)
      |> move()
    end

    def seat_id(%Plane{row: row, col: col}) do
      row * @multiplier + col
    end

    defp new_back(front, back),
      do: back |> Kernel.-(front) |> Kernel.+(1) |> div(2) |> Kernel.+(front) |> Kernel.-(1)

    defp new_front(front, back),
      do: back |> Kernel.-(front) |> Kernel.+(1) |> div(2) |> Kernel.+(front)
  end

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Plane.new(movements: String.split(line, "", trim: true))
      |> Plane.move()
      |> Plane.seat_id()
    end)
    |> Enum.max()
  end

  def part2(args) do
    seats =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        Plane.new(movements: String.split(line, "", trim: true))
        |> Plane.move()
        |> Plane.seat_id()
      end)

    min = Enum.min(seats)
    max = Enum.max(seats)

    MapSet.difference(
      MapSet.new(min..max),
      MapSet.new(seats)
    )
    |> MapSet.to_list()
    |> List.first()
  end
end
