defmodule Day18.Part1 do
  def ins({"snd", x}, acc, idx) do
    {:cont, {Map.put(acc, :snd, Map.get(acc, x, 0)), idx + 1}}
  end
  def ins({"set", x, y}, acc, idx) do
    {:cont, {Map.put(acc, x, safe_parse(acc, y)), idx + 1}}
  end
  def ins({"add", x, y}, acc, idx) do
    {:cont, {Map.put(acc, x,  Map.get(acc, x, 0) + safe_parse(acc, y)), idx + 1}}
  end
  def ins({"mul", x, y}, acc, idx) do
    {:cont, {Map.put(acc, x, Map.get(acc, x, 0) * String.to_integer(y)), idx + 1}}
  end
  def ins({"mod", x, y}, acc, idx) do
    {:cont, {Map.put(acc, x, rem( Map.get(acc, x, 0), safe_parse(acc, y))), idx + 1}}
  end
  def ins({"rcv", x}, acc, idx) do
    cond do
      Map.get(acc, x, 0) != 0 -> {:halt, {Map.put(acc, :rcv, acc[:snd]), idx + 1}}
      true -> {:cont, {acc, idx + 1}}
    end
  end
  def ins({"jgz", x, y}, acc, idx) do
    cond do
      safe_parse(acc, x) > 0 -> {:cont, {acc, idx + safe_parse(acc, y)}}
      true -> {:cont, {acc, idx + 1}}
    end
  end
  def safe_parse(acc, x) do
    case Integer.parse(x) do
      :error ->  Map.get(acc, x, 0)
      {x, _rest} -> x
    end
  end
end

defmodule Day18.Part2 do
  def ins({"snd", x}, acc, idx) do
    acc = acc |> Map.put(:count, Map.get(acc, :count, 0) + 1)
    {acc, idx + 1, [safe_parse(acc, x)], false}
  end
  def ins({"set", x, y}, acc, idx) do
    {Map.put(acc, x, safe_parse(acc, y)), idx + 1, [], false}
  end
  def ins({"add", x, y}, acc, idx) do
    {Map.put(acc, x,  Map.get(acc, x, 0) + safe_parse(acc, y)), idx + 1, [], false}
  end
  def ins({"mul", x, y}, acc, idx) do
    {Map.put(acc, x, Map.get(acc, x, 0) * String.to_integer(y)), idx + 1, [], false}
  end
  def ins({"mod", x, y}, acc, idx) do
    {Map.put(acc, x, rem( Map.get(acc, x, 0), safe_parse(acc, y))), idx + 1, [], false}
  end
  def ins({"rcv", x}, acc, idx) do
    cond do
      acc[:queue] != [] ->
        [h|t] = acc[:queue]
        acc = acc |> Map.put(x, h) |> Map.put(:queue, t)
        {acc, idx + 1, [], false}
      true -> {acc, idx, [], true}
    end
  end
  def ins({"jgz", x, y}, acc, idx) do
    cond do
      safe_parse(acc, x) > 0 -> {acc, idx + safe_parse(acc, y), [], false}
      true -> {acc, idx + 1, [], false}
    end
  end
  def safe_parse(acc, x) do
    case Integer.parse(x) do
      :error ->  Map.get(acc, x, 0)
      {x, _rest} -> x
    end
  end
end

input =
  File.read!("day18_input.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn(x) -> String.split(x) |> List.to_tuple end)

{ans, _i} =
  Stream.cycle([1])
  |> Enum.reduce_while( {%{}, 0} , fn(_x, { acc, idx }) -> Day18.Part1.ins(Enum.at(input, idx), acc, idx) end)

IO.inspect ans[:rcv]

{_ans, _i, ans2, _i2} =
  Stream.cycle([1])
  |> Enum.reduce_while( {%{"p" => 0, queue: []}, 0, %{"p" => 1, queue: []}, 0} , fn(_x, { acc, idx, acc2, idx2 }) ->
    {acc, idx, new2, stuck} = Day18.Part2.ins(Enum.at(input, idx), acc, idx)
    {acc2, idx2, new, stuck2} = Day18.Part2.ins(Enum.at(input, idx2), acc2, idx2)

    acc = acc |> Map.put(:queue, acc[:queue] ++ new)
    acc2 = acc2 |> Map.put(:queue, acc2[:queue] ++ new2)

    cont_or_halt = unless stuck and stuck2, do: :cont, else: :halt

    {cont_or_halt, {acc, idx, acc2, idx2}}
  end)

IO.inspect ans2[:count]
