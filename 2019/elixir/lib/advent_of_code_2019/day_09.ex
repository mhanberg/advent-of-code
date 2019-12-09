defmodule AdventOfCode2019.Day09 do
  def part1(args) do
    program = args |> parse_args

    {:ok, _} = Vm.start_link(:e, program, [1], [], nil, self())

    receive do
      output ->
       GenServer.stop(:e)

       output 
    end
  end

  def part2(args) do
    program = args |> parse_args

    {:ok, _} = Vm.start_link(:e, program, [2], [], nil, self())

    receive do
      output ->
       GenServer.stop(:e)

       output 
    end
  end

  defp parse_args(args) do
    args
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {opcode, i}, map ->
      Map.put(map, i, opcode)
    end)
  end
end
