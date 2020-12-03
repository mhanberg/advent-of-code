defmodule Grid do
  defmodule Cell do
    defstruct [:x, :y, :value]
  end

  defstruct [:cells, :height, :width]

  def new(input) do
    for {line, y} <- lines = split_with_index("\n", input),
        {cell, x} <- split_with_index("", line),
        reduce: %Grid{cells: %{}} do
      %Grid{cells: cells} = grid ->
        struct(grid,
          cells: Map.put(cells, {x, y}, %Cell{x: x, y: y, value: cell}),
          height: Enum.count(lines),
          width: String.length(line)
        )
    end
  end

  def at(%Grid{cells: cells, width: width}, {x, y}) do
    x = rem(x, width)

    cells[{x, y}] || %Cell{}
  end

  defp split_with_index(by, text) do
    text |> String.split(by, trim: true) |> Enum.with_index()
  end
end
