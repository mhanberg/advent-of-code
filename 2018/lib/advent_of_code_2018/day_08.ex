defmodule AdventOfCode2018.Day08 do
  defdelegate part1(args), to: __MODULE__.Part1
  defdelegate part2(args), to: __MODULE__.Part2

  defmodule Part1 do
    def part1(args) do
      {:ok, ag} = Agent.start(fn -> [] end)

      args
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> parse(ag)

      ag
      |> Agent.get(& &1)
      |> Enum.sum()
    end

    defp parse([child_nodes, metadata_values | rest], ag),
      do: parse_children(rest, child_nodes, metadata_values, ag)

    defp parse_children(rest, 0, parent_metadata_values, ag) do
      metadata = AdventOfCode2018.Day08.pop_metadata(rest, parent_metadata_values) |> elem(0)

      Agent.update(ag, &Kernel.++(&1, metadata))

      rest
    end

    defp parse_children(rest, children_left, parent_metadata_values, ag) do
      [child_nodes, metadata_values | rest] = rest

      {metadata, rest} =
        if(child_nodes > 0,
          do: parse_children(rest, child_nodes, metadata_values, ag),
          else: rest
        )
        |> AdventOfCode2018.Day08.pop_metadata(metadata_values)

      unless child_nodes > 0, do: Agent.update(ag, &Kernel.++(&1, metadata))

      parse_children(rest, children_left - 1, parent_metadata_values, ag)
    end
  end

  defmodule Part2 do
    def part2(args) do
      args
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> parse()
    end

    defp parse([child_nodes, metadata_values | rest]),
      do: parse_children(rest, child_nodes, [], metadata_values)

    defp parse_children(rest, 0, children, parent_metadata_values) do
      children = children |> Enum.reverse()
      {metadata, new_rest} = AdventOfCode2018.Day08.pop_metadata(rest, parent_metadata_values)

      value =
        Enum.map(metadata, fn m -> Enum.at(children, m - 1, 0) end)
        |> Enum.sum()

      if Enum.empty?(new_rest) do
        value
      else
        {rest, value}
      end
    end

    defp parse_children(rest, children_left, children, parent_metadata_values) do
      [child_nodes, metadata_values | rest] = rest

      {rest, value} =
        if(child_nodes > 0,
          do: parse_children(rest, child_nodes, [], metadata_values),
          else: {rest, nil}
        )

      {metadata, rest} =
        rest
        |> AdventOfCode2018.Day08.pop_metadata(metadata_values)

      updated_children =
        unless child_nodes > 0, do: [Enum.sum(metadata) | children], else: [value | children]

      parse_children(rest, children_left - 1, updated_children, parent_metadata_values)
    end
  end

  def pop_metadata(nodes, num) do
    Enum.split(nodes, num)
  end
end
