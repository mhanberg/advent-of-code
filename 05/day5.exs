defmodule Day5 do
  def part1(list, index, acc) do
    l = length(list)
    case new_index = Enum.at(list, index) + index do
      ^l -> acc + 1
      _ -> list |> List.update_at(index, &(&1 + 1)) |> part1(new_index, acc + 1)
    end
  end

  def part2(list, index, acc, len) do
    offset = list[index]
    new_index = offset + index

    if new_index >= len do
      acc + 1
    else
      if offset >= 3 do
        %{ list | index => offset - 1 } |> part2(new_index, acc + 1, len)
      else
        %{ list | index => offset + 1 } |> part2(new_index, acc + 1, len)
      end
    end
  end
end

File.read!("day5_input.txt")
  |> String.split(~r{\n}, trim: true)
  |> Enum.map(&(String.to_integer(&1)))
  |> Day5.part1(0, 0)
  |> IO.puts

input = File.read!("day5_input.txt")
  |> String.split(~r{\n}, trim: true)
  |> Enum.with_index
  |> Enum.reduce(%{}, fn({value, index}, acc) -> Map.put(acc, index, String.to_integer(value)) end)

input
  |> Day5.part2(0, 0, length(Map.keys(input)))
  |> IO.puts
