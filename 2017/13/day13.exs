defmodule Day13 do
  def traverse(input, delay) do
    0..(Map.keys(input) |> Enum.max)
    |> Enum.reduce({0, 0}, fn(x, {acc, acc2}) ->
      {zap, range} = case input[x] do
        nil -> {nil, nil}
        r -> {rem(x + delay, 2 * (r - 1)) == 0, r}
      end
      {acc, acc2} = case zap do
        true -> {acc + x * range, acc2 + 1}
        _ -> {acc, acc2}
      end
      {acc, acc2}
    end)
  end
end

input = File.read!("day13_input.txt")
|> String.split("\n", trim: true)
|> Enum.reduce(%{}, fn(x, acc) ->
  [a, b] = String.split(x, ":")
  Map.put(acc, String.to_integer(a), String.trim(b) |> String.to_integer)
end)

{s, _z} = Day13.traverse(input, 0) # Part 1
IO.inspect s

1..9000000 # Part 2
|> Enum.reduce_while(0, fn(x, _acc) ->
  {_s, z} = Day13.traverse(input, x)
  cond do
    z == 0 -> {:halt, x}
    true -> {:cont, x}
  end
end)
|> IO.inspect
