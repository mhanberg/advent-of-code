# Part 1
{parents, children} = File.read!("day7_input.txt")
# {parents, children} = File.read!("day7_sampleinput.txt")
  |> String.split(~r{\n}, trim: true)
  |> Enum.filter(&(String.contains?(&1, "->")))
  |> Enum.reduce({[], []}, fn(x, {parents, children}) ->
      l = String.split(x) |> Enum.map(&(String.trim(&1, ",")))
      { [ List.first(l) | parents ], Enum.slice(l, 3, length(l)) ++ children }
    end)

root = parents
  |> Enum.reduce("", fn(x, acc) ->
      case Enum.find(children, &(&1 == x)) do
        nil -> x
        _ -> acc
      end
    end)
  |> IO.inspect

# Part 2

defmodule Day7 do
  def weight(tree, prog, n, parent) do
    weight = prog[:children]
      |> Enum.reduce(prog.weight, fn(x, acc) ->
        acc + weight(tree, tree[x], n + 1, prog[:self])
      end)
    IO.inspect String.pad_leading("#{prog.self}: #{weight}, self_weight: #{prog.weight}, parent: #{parent}", n * 18)

    weight
  end
end

tree = File.read!("day7_input.txt")
# tree = File.read!("day7_sampleinput.txt")
  |> String.split(~r{\n}, trim: true)
  |> Enum.reduce(%{}, fn(x, acc) ->
      l = String.split(x) |> Enum.map(&(String.trim(&1, ",")))

      Map.put(acc, List.first(l), %{
          weight: Enum.at(l, 1) |> String.trim("(") |> String.trim(")") |> String.to_integer,
          children: Enum.slice(l, 3, length(l)),
          self: List.first(l)
        })
    end)
  # |> IO.inspect

  Day7.weight(tree, tree[root], 0, nil) |> IO.inspect

  # Enum.reduce(tree[root])


