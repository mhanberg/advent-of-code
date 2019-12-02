defmodule AdventOfCode2019.Day02 do
  def part1(args) do
    args |> parse_args |> traverse_codes(0)
  end

  defp traverse_codes(opcode_map, pos) do
    case opcode_map[pos] do
      1 ->
        adjust_codes(opcode_map, pos, &Kernel.+/2)
        |> traverse_codes(pos + 4)

      2 ->
        adjust_codes(opcode_map, pos, &Kernel.*/2)
        |> traverse_codes(pos + 4)

      99 ->
        opcode_map
    end
  end

  defp adjust_codes(opcode_map, pos, adjuster) do
    x1 = opcode_map[pos + 1]
    x2 = opcode_map[pos + 2]

    Map.put(opcode_map, opcode_map[pos + 3], apply(adjuster, [opcode_map[x1], opcode_map[x2]]))
  end

  def part2(args) do
    {_, noun, verb} =
      for noun <- 0..99, verb <- 0..99 do
        Task.async(fn ->
          output =
            args
            |> parse_args
            |> Map.put(1, noun)
            |> Map.put(2, verb)
            |> traverse_codes(0)
            |> Map.get(0)

          {output, noun, verb}
        end)
      end
      |> Enum.map(&Task.await/1)
      |> Enum.find(fn {output, _noun, _verb} -> output == 19_690_720 end)

    100 * noun + verb
  end

  defp parse_args(args) do
    args
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {opcode, i}, map ->
      Map.put(map, i, opcode)
    end)
  end
end
