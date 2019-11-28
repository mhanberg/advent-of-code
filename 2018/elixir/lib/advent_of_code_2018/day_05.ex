defmodule AdventOfCode2018.Day05 do
  def part1(args) do
    args
    |> String.split("", trim: true)
    |> List.to_tuple()
    |> react(0, false)
    |> tuple_size()
  end

  def part2(args) do
    polymer =
      args
      |> String.split("", trim: true)

    polymer
    |> Stream.map(fn x -> String.downcase(x) end)
    |> Stream.uniq()
    |> Stream.map(fn x -> Stream.reject(polymer, fn y -> x == String.downcase(y) end) end)
    |> Stream.map(fn x ->
      Task.async(fn ->
        x |> Enum.to_list() |> List.to_tuple() |> react(0, false) |> tuple_size()
      end)
    end)
    |> Stream.map(fn x -> Task.await(x, :infinity) end)
    |> Enum.min()
  end

  defp react(polymer, index, action?) when tuple_size(polymer) > index + 1 do
    {new_polymer, new_index, new_action?} =
      if triggered?(elem(polymer, index), elem(polymer, index + 1)) do
        polymer =
          polymer
          |> Tuple.delete_at(index)
          |> Tuple.delete_at(index)

        {polymer, index + 1, true}
      else
        {polymer, index + 1, action?}
      end

    react(new_polymer, new_index, new_action?)
  end

  defp react(polymer, _, true) do
    react(polymer, 0, false)
  end

  defp react(polymer, _, false) do
    polymer
  end

  defp triggered?(unit1, unit2) do
    unit1 != unit2 and String.downcase(unit1) == String.downcase(unit2)
  end
end
