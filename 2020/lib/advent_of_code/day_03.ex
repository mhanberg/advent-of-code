defmodule AdventOfCode.Day03 do
  defmodule State do
    defstruct trees_clunked: 0, current_location: {0, 0}, x_slope: nil, y_slope: nil

    def new(opts \\ []), do: struct(%State{}, opts)

    def clunkeded?("#"), do: 1
    def clunkeded?(_), do: 0

    def trees_clunked?(%State{trees_clunked: trees_clunked}), do: trees_clunked

    def move(%State{current_location: {_, y}} = state, %Grid{height: height})
        when y > height - 1 do
      state
    end

    def move(%State{current_location: {x, y}} = state, %Grid{} = grid) do
      move(
        %State{
          state
          | trees_clunked:
              state.trees_clunked +
                clunkeded?(Grid.at(grid, state.current_location).value),
            current_location: {x + state.x_slope, y + state.y_slope}
        },
        grid
      )
    end
  end

  def part1(args) do
    State.new(x_slope: 3, y_slope: 1)
    |> State.move(Grid.new(args))
    |> State.trees_clunked?()
  end

  def part2(args) do
    grid = Grid.new(args)
    slopes = [
      [x_slope: 1, y_slope: 1],
      [x_slope: 3, y_slope: 1],
      [x_slope: 5, y_slope: 1],
      [x_slope: 7, y_slope: 1],
      [x_slope: 1, y_slope: 2]
    ]

    for slope <- slopes, reduce: 1 do
      product ->
        State.new(slope)
        |> State.move(grid)
        |> State.trees_clunked?()
        |> Kernel.*(product)
    end
  end
end
