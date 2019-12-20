defmodule AdventOfCode2019.Day19 do
  def part1(args) do
    program = Vm.parse(args)

    inputs =
      for x <- 49..0, y <- 49..0, reduce: [] do
        inputs ->
          [[x, y] | inputs]
      end

    inputs
    |> Enum.map(fn [x, y] = input ->
      Task.async(fn ->
        {:ok, pid} = Vm.start_link(nil, program, input, [], self(), self())

        receive do
          {:add_inputs, [output]} ->
            {{{x, y}, output}, pid}
        end
      end)
    end)
    |> Enum.map(fn task ->
      {pixel, server} = Task.await(task)

      Vm.stop(server)

      pixel
    end)
    |> Enum.into(Map.new())
    |> Terminal.clear()
    |> Terminal.render(fn pixels, x, y ->
      case pixels[{x, y}] do
        0 -> "."
        1 -> "#"
        _ -> " "
      end
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def part2(args) do
    program = Vm.parse(args)

    {x, y} = find(0, 0, program)

    (x * 10000) + y
  end

  defp find(x, y, program) do
    cond do
      within_beam?(x, y, program) ->
        if loc = fits?(x, y, program) do
          loc
        else
          find(x, y + 1, program)
        end

      within_beam?(x + 1, y, program) ->
        if loc = fits?(x + 1, y, program) do
          loc
        else
          find(x + 1, y + 1, program)
        end

      true ->
        find(x + 1, y + 1, program)
    end
  end

  defp fits?(x, y, program) do
    if within_beam?(x + 99, y, program) and within_beam?(x, y - 99, program) and
         within_beam?(x + 99, y - 99, program) do
      {x, y - 99}
    else
      false
    end
  end

  defp within_beam?(x, y, program) do
    {:ok, pid} = Vm.start_link(nil, program, [x, y], [], self(), self())

    result =
      receive do
        {:add_inputs, [1]} ->
          true

        {:add_inputs, [0]} ->
          false
      end

    Vm.stop(pid)

    result
  end
end
