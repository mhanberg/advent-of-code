defmodule Day18 do
  def ins({"snd", x}, acc, idx) do
    played = Map.get(acc, x, 0)
    {:cont, {Map.put(acc, :snd, played), idx + 1}}
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

input =
  File.read!("day18_input.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn(x) -> String.split(x) |> List.to_tuple end)

{ans, _i} =
  Stream.cycle([1])
  |> Enum.reduce_while( {%{}, 0} , fn(_x, { acc, idx }) -> Day18.ins(Enum.at(input, idx), acc, idx) end)

IO.inspect ans[:rcv]
