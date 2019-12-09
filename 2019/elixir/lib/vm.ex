defmodule Vm do
  use GenServer

  def start_link(name, program, inputs, outputs, neighbor, main_thread) do
    GenServer.start_link(__MODULE__, {program, inputs, outputs, neighbor, name, main_thread},
      name: name
    )
  end

  def init({program, inputs, outputs, neighbor, name, main_thread}) do
    {:ok,
     %{
       halted?: false,
       program: program,
       inputs: inputs,
       outputs: outputs,
       pos: 0,
       neighbor: neighbor,
       name: name,
       main_thread: main_thread
     }, {:continue, :traverse_codes}}
  end

  def handle_continue(:traverse_codes, state) do
    IO.inspect :continuing # this makes it work??? fuck me

    traversed =
      traverse_codes(
        state.program,
        state.pos,
        state.inputs,
        state.outputs,
        state.neighbor,
        state.main_thread,
        state.name
      )

    new_state = Map.merge(state, traversed)

    {:noreply, new_state}
  end

  def handle_info({:add_inputs, inputs}, state) do
    {:noreply, %{state | inputs: state.inputs ++ inputs}, {:continue, :traverse_codes}}
  end

  defp traverse_codes(opcode_map, pos, inputs, outputs, neighbor, main_thread, name) do
    opcode_map[pos]
    |> to_string()
    |> String.pad_leading(5, "0")
    |> String.split_at(-2)
    |> interpret_code()
    |> case do
      {1, mode1, mode2, mode3} ->
        adjust_codes(opcode_map, pos, mode1, mode2, mode3, &Kernel.+/2)
        |> traverse_codes(pos + 4, inputs, outputs, neighbor, main_thread, name)

      {2, mode1, mode2, mode3} ->
        adjust_codes(opcode_map, pos, mode1, mode2, mode3, &Kernel.*/2)
        |> traverse_codes(pos + 4, inputs, outputs, neighbor, main_thread, name)

      {3, _, _, _} ->
        if Enum.empty?(inputs) do
          %{program: opcode_map, pos: pos, inputs: inputs, outputs: outputs}
        else
          [input | rest] = inputs
          x1 = opcode_map[pos + 1]

          Map.put(opcode_map, x1, input)
          |> traverse_codes(pos + 2, rest, outputs, neighbor, main_thread, name)
        end

      {4, mode, _, _} ->
        [{_, operand}] = get_operands(opcode_map, pos, 1, [mode], [])

        with pid when is_pid(pid) <- Process.whereis(neighbor) do
          send(pid, {:add_inputs, [operand]})
        end

        opcode_map
        |> traverse_codes(pos + 2, inputs, [operand | outputs], neighbor, main_thread, name)

      {5, mode1, mode2, _} ->
        new_pos = jump_if(opcode_map, pos, mode1, mode2, &Kernel.!=/2)

        opcode_map
        |> traverse_codes(new_pos, inputs, outputs, neighbor, main_thread, name)

      {6, mode1, mode2, _} ->
        new_pos = jump_if(opcode_map, pos, mode1, mode2, &Kernel.==/2)

        opcode_map
        |> traverse_codes(new_pos, inputs, outputs, neighbor, main_thread, name)

      {7, mode1, mode2, mode3} ->
        opcode_map
        |> store_if(pos, mode1, mode2, mode3, &Kernel.</2)
        |> traverse_codes(pos + 4, inputs, outputs, neighbor, main_thread, name)

      {8, mode1, mode2, mode3} ->
        opcode_map
        |> store_if(pos, mode1, mode2, mode3, &Kernel.==/2)
        |> traverse_codes(pos + 4, inputs, outputs, neighbor, main_thread, name)

      {99, _, _, _} ->
        if name == :e, do: send(main_thread, outputs)

        %{program: opcode_map, pos: pos, inputs: inputs, outputs: outputs, halted?: true}
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
end
