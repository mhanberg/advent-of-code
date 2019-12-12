defmodule AdventOfCode2019.Day05 do
  def part1(args, input) do
    program = args |> Vm.parse()

    Vm.start_link(:e, program, [input], [], nil, self())

    receive do
      output ->
        GenServer.stop(:e)

        output
    end
  end

  def part2(args, input) do
    program = args |> Vm.parse()

    Vm.start_link(:e, program, [input], [], nil, self())

    receive do
      output ->
        GenServer.stop(:e)

        output
    end
  end
end
