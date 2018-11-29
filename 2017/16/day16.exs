defmodule Day16 do
  def left_rotate(l, n \\ 1)
  def left_rotate([], _), do: []
  def left_rotate(l, 0), do: l
  def left_rotate([h | t], 1), do: t ++ [h]
  def left_rotate(l, n) when n > 0, do: left_rotate(left_rotate(l, 1), n-1)

  def right_rotate(l, n \\ 1)
  def right_rotate(l, n) when n > 0, do: Enum.reverse(l) |> left_rotate(n) |> Enum.reverse
  def right_rotate(l, n), do: left_rotate(l, -n)

  def spin(progs, num) do
    right_rotate(progs, num)
  end

  def exchange(progs, pos_a, pos_b) do
    a = Enum.at(progs, pos_a)
    b = Enum.at(progs, pos_b)

    List.replace_at(progs, pos_a, b)
    |> List.replace_at(pos_b, a)
  end

  def partner(progs, a, b) do
    pos_a = Enum.find_index(progs, fn(val) -> val == a end)
    pos_b = Enum.find_index(progs, fn(val) -> val == b end)

    exchange(progs, pos_a, pos_b)
  end

  def dance(moves, progs) do
    moves
    |> Enum.reduce(progs, fn({dm, args}, acc) ->
      case dm do
        "s" -> Day16.spin(acc, List.first(args))
        "x" ->
          Day16.exchange(acc, List.first(args), List.last(args))
        "p" ->
          Day16.partner(acc, List.first(args), List.last(args))
      end
    end)
  end
end

progs = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"]

dance_moves =
  File.read!("day16_input.txt")
  |> String.split(",")
  |> Enum.map(fn(x) ->
    x = x |> String.trim
    {dm, args} = String.split_at(x, 1)
    args = String.split(args, "/") |> Enum.map(fn(x) ->
      case dm do
        "s" -> String.to_integer(x)
        "x" -> String.to_integer(x)
        "p" -> x
      end
    end)
    {dm, args}
  end)

dance_moves
|> Day16.dance(progs)
|> Enum.join
|> IO.inspect

1..rem(1_000_000_000, 60)
|> Enum.reduce(progs, fn(_x, acc) -> Day16.dance(dance_moves, acc) end)
|> Enum.join
|> IO.inspect
