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
       relative_base: 0,
       main_thread: main_thread
     }, {:continue, :execute}}
  end

  def handle_continue(:execute, state) do
    traversed = execute(state)

    new_state = Map.merge(state, traversed)

    {:noreply, new_state}
  end

  def handle_info({:add_inputs, inputs}, state) do
    new_state = %{state | inputs: state.inputs ++ List.wrap(inputs)}

    if state.halted? do
      {:noreply, %{new_state | halted?: false}, {:continue, :execute}}
    else
      {:noreply, new_state}
    end
  end

  defp execute(state) do

    state.program[state.pos]
    |> to_string()
    |> String.pad_leading(5, "0")
    |> String.split_at(-2)
    |> interpret_code()
    |> case do
      {1, mode1, mode2, mode3} ->
        execute(%{
          state
          | program: adjust_codes(state, mode1, mode2, mode3, &Kernel.+/2),
            pos: state.pos + 4
        })

      {2, mode1, mode2, mode3} ->
        execute(%{
          state
          | program: adjust_codes(state, mode1, mode2, mode3, &Kernel.*/2),
            pos: state.pos + 4
        })

      {3, mode, _, _} ->
        if Enum.empty?(state.inputs) do
          send(state.main_thread, {:get_current_panel_color, self()})

          %{
            state
            | halted?: true
          }
        else
          [input | rest] = state.inputs

          execute(%{
            state
            | program:
                Map.put(
                  state.program,
                  write_position(state, state.program[state.pos + 1], mode),
                  input
                ),
              pos: state.pos + 2,
              inputs: rest
          })
        end

      {4, mode, _, _} ->
        [{_, operand}] = get_operands(state, 1, [mode], [])

        if state.neighbor != nil,
          do:
            if(is_pid(state.neighbor),
              do: send(state.neighbor, {:add_inputs, [operand]}),
              else: send(Process.whereis(state.neighbor), {:add_inputs, [operand]})
            )

        execute(%{
          state
          | pos: state.pos + 2,
            outputs: [operand | state.outputs]
        })

      {5, mode1, mode2, _} ->
        execute(%{state | pos: jump_if(state, mode1, mode2, &Kernel.!=/2)})

      {6, mode1, mode2, _} ->
        execute(%{state | pos: jump_if(state, mode1, mode2, &Kernel.==/2)})

      {7, mode1, mode2, mode3} ->
        execute(%{
          state
          | program: store_if(state, mode1, mode2, mode3, &Kernel.</2),
            pos: state.pos + 4
        })

      {8, mode1, mode2, mode3} ->
        execute(%{
          state
          | program: store_if(state, mode1, mode2, mode3, &Kernel.==/2),
            pos: state.pos + 4
        })

      {9, mode, _, _} ->
        [{_, operand}] = get_operands(state, 1, [mode], [])

        new_base = (state.relative_base + operand)

        execute(%{
          state
          | pos: state.pos + 2,
            relative_base: new_base
        })

      {99, _, _, _} ->
        if state.name == :e, do: send(state.main_thread, state.outputs)

        state
    end
  end

  defp adjust_codes(state, mode1, mode2, mode3, adjuster) do
    [{_, operand1}, {_, operand2}, {parameter3, _}] =
      get_operands(state, 1, [mode1, mode2, mode3], [])

    Map.put(
      state.program,
      write_position(state, parameter3, mode3),
      apply(adjuster, [operand1, operand2])
    )
  end

  def get_operands(_, _, [], operands), do: Enum.reverse(operands)

  def get_operands(state, moving, [mode | modes], operands) do
    parameter = state.program[state.pos + moving]
    operand = get_by_mode(state, parameter, mode)

    get_operands(state, moving + 1, modes, [{parameter, operand} | operands])
  end

  # position
  def get_by_mode(state, parameter, 0) do
    state.program[parameter] || 0
  end

  # immediate
  def get_by_mode(_, parameter, 1) do
    parameter
  end

  # relative
  def get_by_mode(state, parameter, 2) do
    state.program[state.relative_base + parameter] || 0
  end

  # position
  def write_position(_state, parameter, 0) do
    parameter
  end

  # relative
  def write_position(state, parameter, 2) do
    state.relative_base + parameter
  end

  def jump_if(state, mode1, mode2, tester) do
    [{_, operand1}, {_, operand2}] = get_operands(state, 1, [mode1, mode2], [])

    if(tester.(operand1, 0), do: operand2, else: state.pos + 3)
  end

  def store_if(state, mode1, mode2, mode3, tester) do
    [{_, operand1}, {_, operand2}, {parameter3, _}] =
      get_operands(state, 1, [mode1, mode2, mode3], [])

    Map.put(
      state.program,
      write_position(state, parameter3, mode3),
      if(tester.(operand1, operand2), do: 1, else: 0)
    )
  end

  def interpret_code({"", code}), do: {String.to_integer(code), 0, 0, 0}

  def interpret_code({modes, code}),
    do: modes |> interpret_modes |> interpret_code(String.to_integer(code))

  def interpret_code([mode1, mode2, mode3], code), do: {code, mode1, mode2, mode3}

  def interpret_modes(modes),
    do: modes |> String.split("", trim: true) |> Enum.reverse() |> Enum.map(&String.to_integer/1)

  def parse(args) do
    args
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {opcode, i}, map ->
      Map.put(map, i, opcode)
    end)
  end
end
