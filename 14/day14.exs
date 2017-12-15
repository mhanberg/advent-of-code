use Bitwise

defmodule Day14 do
  def hash(input) do
    input = Stream.cycle(input) |> Enum.take(length(input) * 64)
    list = (0..255) |> Enum.reduce(%{}, fn(b, acc) -> Map.put(acc, b, b) end)

    {output, _p, _s} =
      input
      |> Enum.reduce({list, 0, 0}, fn(x, {acc, pos, skip}) ->
        reversed = Enum.map(0..(x-1), fn(y) -> acc[rem(pos + y, 256)] end)
        |> Enum.reverse

        acc = Enum.reduce(0..(x-1), %{}, fn(y, acc) -> Map.put(acc, rem(pos + y, 256), Enum.at(reversed, y)) end)
        |> Enum.into(acc)

        {acc, rem(pos + x + skip, 256), skip + 1}
      end)
    0..15
    |> Enum.map(fn(x) -> output[x * 16 + 0] ^^^ output[x * 16 + 1] ^^^ output[x * 16 + 2] ^^^ output[x * 16 + 3] ^^^ output[x * 16 + 4] ^^^ output[x * 16 + 5] ^^^ output[x * 16 + 6] ^^^ output[x * 16 + 7] ^^^ output[x * 16 + 8] ^^^ output[x * 16 + 9] ^^^ output[x * 16 + 10] ^^^ output[x * 16 + 11] ^^^ output[x * 16 + 12] ^^^ output[x * 16 + 13] ^^^ output[x * 16 + 14] ^^^ output[x * 16 + 15] end)
    |> Enum.map(fn(x) ->
      Integer.to_charlist(x, 2) |> to_string |> String.pad_leading(8, "0")
    end)
    |> Enum.join
    |> String.downcase
  end

  @directions [ {1, 0}, {0, 1}, {-1, 0}, {0, -1} ]
  def groups(disk, {x, y}) do
    neighbors =
      @directions
      |> Enum.map(fn({x1, y1}) ->
        nx = x + x1
        ny = y + y1
        block = disk[{nx, ny}]
        cond do
          block[:value] == "1"  ->
            {nx, ny}
          true -> nil
        end
      end)
      |> Enum.reject(&is_nil/1)
    put_in(disk, [{x, y}, :neighbors], neighbors)
  end

  def path_finder(m, pos, acc) do
    new_pipes = Enum.reject(m[pos], &(Enum.member?(acc, &1)))
    Enum.reduce(new_pipes, acc ++ new_pipes, &(path_finder(m, &1, &2)))
  end

  def path_count(m, acc) do
    pos = Map.keys(m) |> Enum.sort |> List.first
    keys_to_drop = path_finder(m, pos, [])

    m = cond do
      Enum.empty?(keys_to_drop) -> Map.drop(m, [pos])
      true -> Map.drop(m, keys_to_drop)
    end

    cond do
      Enum.empty?(m) -> acc + 1
      true -> path_count(m, acc + 1)
    end
  end
end

input = "hwlqcszp"
hdd = (0..127)
  |> Enum.map(fn(a) ->
    input = '#{input}-#{a}' ++ [17, 31, 73, 47, 23]
    Day14.hash(input)
  end)

hdd # Part 1
|> Enum.reduce(0, fn(x, acc) ->
  acc + (x |> String.graphemes |> Enum.reject(&(&1 == "0")) |> Enum.count)
end)
|> IO.inspect

disk = hdd
  |> Enum.with_index
  |> Enum.reduce(%{}, fn({a, y}, acc) ->
    a
    |> String.graphemes
    |> Enum.with_index
    |> Enum.reduce(acc, fn({v, x}, acc2) ->
      Map.put(acc2, {x, y}, %{value: v})
    end)
  end)

disk
|> Enum.reduce(disk, fn({k, _v}, acc) ->
  case acc[k].value do
    "1" -> Day14.groups(acc, k)
    _ -> acc
  end
end)
|> Enum.reduce(%{}, fn({k, v}, acc) ->
  case v[:neighbors] do
    nil -> acc
    _ -> Map.put(acc, k, v[:neighbors])
  end
end)
|> Day14.path_count(0)
|> IO.inspect
