input = 335

{l, p} = Enum.reduce(1..2017, {[0], 0}, fn(x, {acc, pos}) ->
  new_pos = rem(pos + input, length(acc)) + 1
  {List.insert_at(acc, new_pos, x), new_pos}
end)

IO.inspect Enum.at(l, p + 1)

{one, _p} = Enum.reduce(1..50_000_000, {0, 0}, fn(x, {acc, pos}) ->
  new_pos = rem(pos + input, x) + 1

  case new_pos do
    1 -> {x, new_pos}
    _ -> {acc, new_pos}
  end
end)

IO.inspect one
