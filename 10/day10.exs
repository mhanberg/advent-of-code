input = [230,1,2,221,97,252,168,169,57,99,0,254,181,255,235,167] # Part 1
# input = '230,1,2,221,97,252,168,169,57,99,0,254,181,255,235,167' ++ [17, 31, 73, 47, 23] # Part 2
# input = Stream.cycle(input) |> Enum.take(length(input) * 64)
list = (0..255) |> Enum.reduce(%{}, fn(x, acc) -> Map.put(acc, x, x) end)

use Bitwise

{output, _p, _s} =
  input
  |> Enum.reduce({list, 0, 0}, fn(x, {acc, pos, skip}) ->
      reversed = Enum.map(0..(x-1), fn(y) -> acc[rem(pos + y, 256)] end)
      |> Enum.reverse

      acc = Enum.reduce(0..(x-1), %{}, fn(y, acc) -> Map.put(acc, rem(pos + y, 256), Enum.at(reversed, y)) end)
      |> Enum.into(acc)

      {acc, rem(pos + x + skip, 256), skip + 1}
  end)
IO.inspect output[0] * output[1] # Part 1

# 0..15
# |> Enum.map(fn(x) -> output[x * 16 + 0] ^^^ output[x * 16 + 1] ^^^ output[x * 16 + 2] ^^^ output[x * 16 + 3] ^^^ output[x * 16 + 4] ^^^ output[x * 16 + 5] ^^^ output[x * 16 + 6] ^^^ output[x * 16 + 7] ^^^ output[x * 16 + 8] ^^^ output[x * 16 + 9] ^^^ output[x * 16 + 10] ^^^ output[x * 16 + 11] ^^^ output[x * 16 + 12] ^^^ output[x * 16 + 13] ^^^ output[x * 16 + 14] ^^^ output[x * 16 + 15] end)
# |> Enum.map(fn(x) ->
#   Integer.to_charlist(x, 16) |> to_string |> String.pad_leading(2, "0")
# end)
# |> Enum.join
# |> String.downcase
# |> IO.inspect
