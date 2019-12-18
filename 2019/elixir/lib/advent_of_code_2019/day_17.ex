defmodule AdventOfCode2019.Day17 do
  def part1(args) do
    program = Vm.parse(args)

    {:ok, _} = Vm.start_link(:e, program, [], [], self(), self())

    state = await(%{loc: {0, 0}, map: %{}})

    state.map
    |> Enum.map(fn {{x, y}, _} ->
      if state.map[{x - 1, y}] && state.map[{x + 1, y}] && state.map[{x, y - 1}] &&
           state.map[{x, y + 1}] do
        x * y
      else
        0
      end
    end)
    |> Enum.sum()
  end

  defp await(%{loc: {x, y}, map: map} = state) do
    receive do
      {:add_inputs, [input]} ->
        IO.write([input])

        new_state =
          case input do
            ?\n ->
              %{
                loc: {0, y + 1},
                map: map
              }

            code when code in '^<>v.' ->
              %{
                loc: {x + 1, y},
                map: map
              }

            _ ->
              %{
                loc: {x + 1, y},
                map: Map.put(map, {x, y}, input)
              }
          end

        await(new_state)

      _ ->
        GenServer.stop(:e)

        state
    end
  end

  def part2(args) do
    program = Vm.parse(args)

    {:ok, _} = Vm.start_link(:e, program, [], [], self(), self())

    state =
      await2(%{
        loc: {0, 0},
        map: %{},
        instructions:
          'A,B,A,C,B,C,A,B,A,C\nR,10,L,8,R,10,R,4\nL,6,L,6,R,10\nL,6,R,12,R,12,R,10\nn\n'
      })
  end

  # A,B,A,C,B,C,A,B,A,C
  # R,10,L,8,R,10,R,4
  # L,6,L,6,R,10
  # L,6,R,12,R,12,R,10
  defp await2(%{loc: {x, y}, map: map} = state) do
    receive do
      {:add_inputs, [input]} ->
        IO.write([input])

        new_state =
          case input do
            ?\n ->
              %{
                state
                | loc: {0, y + 1},
                  map: map
              }

            code when code in '^<>v.' ->
              %{
                state
                | loc: {x + 1, y},
                  map: map
              }

            _ ->
              %{
                state
                | loc: {x + 1, y},
                  map: Map.put(map, {x, y}, input)
              }
          end

        await2(new_state)

      {:request_input, pid} ->
        [ins | rest] = state.instructions

        send(pid, {:add_inputs, [ins]})

        await2(%{state | instructions: rest})

      [lint | _] ->
        GenServer.stop(:e)

        lint
    end
  end
end
