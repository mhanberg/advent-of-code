defmodule AdventOfCode2018.Day01 do
  def part1(args) do
    args
    |> Enum.reduce(0, fn x, acc ->
      acc + String.to_integer(x)
    end)
  end

  def part2(args) do
    find_dup(args, {0, []}, args)
  end

  defp find_dup([], acc, full_args) do
    find_dup(full_args, acc, full_args)
  end

  defp find_dup(args, {acc, cycle_list}, full_args) do
    [x | tail] = args
    new_acc = acc + String.to_integer(x)

    if Enum.member?(cycle_list, new_acc) do
      new_acc
    else
      new_cycle_list = [new_acc | cycle_list]

      find_dup(tail, {new_acc, new_cycle_list}, full_args)
    end
  end
end
