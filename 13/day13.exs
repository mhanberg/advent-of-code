defmodule Day13 do
  def scan(firewall) do
    firewall
    |> Enum.reduce(firewall, &move/2)
  end

  defp move({k, %{range: r, pos: p, dir: :down} = v}, acc) when p == r do
    acc
    |> Map.put(k, Map.merge(v, %{pos: p - 1, dir: :up}))
  end

  defp move({k, %{range: _r, pos: p, dir: :down} = v}, acc) do
    acc
    |> Map.put(k, Map.merge(v, %{pos: p + 1}))
  end

  defp move({k, %{range: _r, pos: p, dir: :up} = v}, acc) when p == 1 do
    acc
    |> Map.put(k, Map.merge(v, %{pos: p + 1, dir: :down}))
  end

  defp move({k, %{range: _r, pos: p, dir: :up} = v}, acc) do
    acc
    |> Map.put(k, Map.merge(v, %{pos: p - 1}))
  end
end

input = File.read!("day13_input.txt")
|> String.split("\n", trim: true)
|> Enum.reduce(%{}, fn(x, acc) ->
  [a, b] = String.split(x, ":")
  Map.put(acc, String.to_integer(a), %{range: String.trim(b) |> String.to_integer, pos: 1, dir: :down})
end)

{severity, _f} =
  0..(Map.keys(input) |> Enum.max)
  |> Enum.reduce({0, input}, fn(x, {acc, firewall}) ->
    scanner = firewall[x]
    acc = case scanner[:pos] do
      1 -> acc + x * scanner[:range]
      _ -> acc
    end
    {acc, Day13.scan(firewall)}
  end)

IO.inspect severity
