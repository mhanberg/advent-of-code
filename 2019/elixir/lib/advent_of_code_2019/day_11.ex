defmodule AdventOfCode2019.Day11 do
  alias __MODULE__.HullPainter

  def part1(args) do
    vm = Vm.parse(args)

    {:ok, _} = Vm.start_link(:e, vm, [], [], self(), self())

    hull_painter = HullPainter.new()

    hull_painter
    |> await_input()
    |> Map.get(:hull)
    |> Enum.count()
  end

  defp await_input(hull_painter) do
    receive do
      {:get_current_panel_color, pid} ->
        send(pid, {:add_inputs, HullPainter.get_current_panel_color(hull_painter)})

        await_input(hull_painter)

      {:add_inputs, [input]} ->
        hull_painter
        |> HullPainter.act(hull_painter.state, input)
        |> await_input()

      output ->
        hull_painter
    end
  end

  def part2(_args) do
  end

  defmodule HullPainter do
    defstruct hull: Map.new(), location: {0, 0}, direction: :up, state: :paint

    def new do
      %__MODULE__{}
    end

    def act(hull_painter, :paint, color) do
      hull_painter
      |> paint(color)
      |> struct(state: :rotate)
    end

    def act(hull_painter, :rotate, direction) do
      struct(
        hull_painter,
        direction: rotate(hull_painter.direction, rotation(direction)),
        state: :move
      )
      |> act(:move)
    end

    def act(hull_painter, :move) do
      hull_painter =
        struct(
          hull_painter,
          location: move(hull_painter.location, hull_painter.direction),
          state: :paint
        )

      hull_painter
    end

    def get_current_panel_color(hull_painter) do
      Map.get(hull_painter.hull, hull_painter.location, [:black])
      |> List.first()
      |> case do
        :black -> 0
        :white -> 1
      end
    end

    defp rotate(:up, :left), do: :left
    defp rotate(:up, :right), do: :right
    defp rotate(:left, :left), do: :down
    defp rotate(:left, :right), do: :up
    defp rotate(:down, :left), do: :right
    defp rotate(:down, :right), do: :left
    defp rotate(:right, :left), do: :up
    defp rotate(:right, :right), do: :down

    defp rotation(0), do: :left
    defp rotation(1), do: :right

    defp paint(hull_painter, 0), do: paint(hull_painter, :black)
    defp paint(hull_painter, 1), do: paint(hull_painter, :white)

    defp paint(hull_painter, color) when is_atom(color) do
      struct(
        hull_painter,
        hull:
          Map.update(
            hull_painter.hull,
            hull_painter.location,
            [color],
            fn paints -> [color | paints] end
          )
      )
    end

    defp move({x, y}, :up), do: {x, y + 1}
    defp move({x, y}, :left), do: {x - 1, y}
    defp move({x, y}, :down), do: {x, y - 1}
    defp move({x, y}, :right), do: {x + 1, y}
  end
end
