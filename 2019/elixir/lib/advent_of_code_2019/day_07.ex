defmodule AdventOfCode2019.Day07 do
  def part1(args) do
    program = args |> parse_args

    for perm <- perms(Enum.to_list(0..4)), into: [] do
      Enum.reduce(perm, 0, fn phase, last_output ->
        Vm.start_link(:e, program, [phase, last_output], [], nil, self())

        receive do
          [output] ->
           GenServer.stop(:e)

           output 
        end
      end)
    end
    |> Enum.max()
  end

  def part2(args) do
    program = args |> parse_args

    main = self()

    for perm <- perms(Enum.to_list(5..9)), into: [] do
      for {amp, phase} <- Enum.zip([:a, :b, :c, :d, :e], perm), into: [] do
        inputs = if amp == :a, do: [phase, 0], else: [phase]

        {:ok, _pid} = Vm.start_link(amp, program, inputs, [], neighbor(amp), main)
      end

      receive do
        output when not is_tuple(output) ->
          Enum.each([:a, :b, :c, :d, :e], &GenServer.stop/1)

          output 
      end
    end
    |> List.flatten()
    |> Enum.max()
  end

  defp neighbor(:a), do: :b
  defp neighbor(:b), do: :c
  defp neighbor(:c), do: :d
  defp neighbor(:d), do: :e
  defp neighbor(:e), do: :a

  defp perms([]), do: [[]]
  defp perms(l), do: for(h <- l, t <- perms(l -- [h]), do: [h | t])

  defp parse_args(args) do
    args
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {opcode, i}, map ->
      Map.put(map, i, opcode)
    end)
  end
end
