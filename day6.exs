defmodule Day6 do
  def redistribute(banks, {index, value}, acc) do
    l = length(Map.keys(banks))
    redistribute(%{ banks | index => 0 }, rem(index + 1, l), value, l, acc)
  end

  def redistribute(banks, _i, 0, _l, acc) do
    cond do
      Enum.any?(acc, &(&1 == banks)) -> {length(acc), Enum.find_index(acc, &(&1 == banks)) + 1}
      true -> redistribute(banks, largest_bank(banks), [banks | acc])
    end
  end

  def redistribute(banks, index, value, l, acc) do
    redistribute(%{ banks | index => banks[index] + 1 }, rem(index + 1, l), value - 1, l, acc)
  end

  def largest_bank(banks) do
    banks |> Enum.max_by(fn({_key, value}) -> value end)
  end
end

input = File.read!("day6_input.txt")
  |> String.split
  |> Enum.with_index
  |> Enum.reduce(%{}, fn({value, index}, acc) -> Map.put(acc, index, String.to_integer(value)) end)

input
  |> Day6.redistribute(Day6.largest_bank(input), [input])
  |> IO.inspect
