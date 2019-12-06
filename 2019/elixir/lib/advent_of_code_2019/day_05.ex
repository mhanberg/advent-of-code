defmodule AdventOfCode2019.Day05 do
  def part1(args, input) do
    args |> parse_args |> traverse_codes(0, input, [])
  end

  def part2(args, input) do
    args |> parse_args |> traverse_codes(0, input, [])
  end

  defp traverse_codes(opcode_map, pos, input, outputs) do
    opcode_map[pos]
    |> to_string()
    |> String.pad_leading(5, "0")
    |> String.split_at(-2)
    |> interpret_code()
    |> case do
      {1, mode1, mode2, mode3} ->
        adjust_codes(opcode_map, pos, mode1, mode2, mode3, &Kernel.+/2)
        |> traverse_codes(pos + 4, input, outputs)

      {2, mode1, mode2, mode3} ->
        adjust_codes(opcode_map, pos, mode1, mode2, mode3, &Kernel.*/2)
        |> traverse_codes(pos + 4, input, outputs)

      {3, _, _, _} ->
        x1 = opcode_map[pos + 1]

        Map.put(opcode_map, x1, input)
        |> traverse_codes(pos + 2, input, outputs)

      {4, mode, _, _} ->
        [{_, operand}] = get_operands(opcode_map, pos, 1, [mode], [])

        opcode_map
        |> traverse_codes(pos + 2, input, [operand | outputs])

      {5, mode1, mode2, _} ->
        new_pos = jump_if(opcode_map, pos, mode1, mode2, &Kernel.!=/2)

        opcode_map
        |> traverse_codes(new_pos, input, outputs)

      {6, mode1, mode2, _} ->
        new_pos = jump_if(opcode_map, pos, mode1, mode2, &Kernel.==/2)

        opcode_map
        |> traverse_codes(new_pos, input, outputs)

      {7, mode1, mode2, mode3} ->
        opcode_map
        |> store_if(pos, mode1, mode2, mode3, &Kernel.</2)
        |> traverse_codes(pos + 4, input, outputs)

      {8, mode1, mode2, mode3} ->
        opcode_map
        |> store_if(pos, mode1, mode2, mode3, &Kernel.==/2)
        |> traverse_codes(pos + 4, input, outputs)

      {99, _, _, _} ->
        {opcode_map, outputs}
    end
  end

  defp adjust_codes(opcode_map, pos, mode1, mode2, mode3, adjuster) do
    [{_, operand1}, {_, operand2}, {locator3, _}] =
      get_operands(opcode_map, pos, 1, [mode1, mode2, mode3], [])

    Map.put(opcode_map, locator3, apply(adjuster, [operand1, operand2]))
  end

  def get_operands(_, _, _, [], operands), do: Enum.reverse(operands)

  def get_operands(opcode_map, pos, moving, [mode | modes], operands) do
    locator = opcode_map[pos + moving]
    operand = get_by_mode(opcode_map, locator, mode)

    get_operands(opcode_map, pos, moving + 1, modes, [{locator, operand} | operands])
  end

  def get_by_mode(opcode_map, locator, 0) do
    opcode_map[locator]
  end

  def get_by_mode(_, locator, 1) do
    locator
  end

  def jump_if(opcode_map, pos, mode1, mode2, tester) do
    [{_, operand1}, {_, operand2}] = get_operands(opcode_map, pos, 1, [mode1, mode2], [])

    if(tester.(operand1, 0), do: operand2, else: pos + 3)
  end

  def store_if(opcode_map, pos, mode1, mode2, mode3, tester) do
    [{_, operand1}, {_, operand2}, {locator3, _}] =
      get_operands(opcode_map, pos, 1, [mode1, mode2, mode3], [])

    Map.put(opcode_map, locator3, if(tester.(operand1, operand2), do: 1, else: 0))
  end

  def interpret_code({"", code}), do: {String.to_integer(code), 0, 0, 0}

  def interpret_code({modes, code}),
    do: modes |> interpret_modes |> interpret_code(String.to_integer(code))

  def interpret_code([mode1, mode2, mode3], code), do: {code, mode1, mode2, mode3}

  def interpret_modes(modes),
    do: modes |> String.split("", trim: true) |> Enum.reverse() |> Enum.map(&String.to_integer/1)

  defp parse_args(args) do
    args
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {opcode, i}, map ->
      Map.put(map, i, opcode)
    end)
  end
end
