defmodule AdventOfCode2019.Day14 do
  require IEx

  def part1(args) do
    look_up_table = parse(args)

    synthesize([{"FUEL", 1}], look_up_table, Map.new(), 0)
  end

  @tril 1_000_000_000_000
  def part2(args) do
    look_up_table = parse(args)

    refine(look_up_table, 0, 10_000_000)
  end

  defp refine(look_up_table, low, high) do
    mids = div(high - low, 2) + low

    case synthesize([{"FUEL", mids}], look_up_table, Map.new(), 0) do
      _ore when high - low == 1 ->
        mids

      ore when ore < @tril ->
        refine(look_up_table, mids, high)

      ore when ore > @tril ->
        refine(look_up_table, low, mids)
    end
  end

  defp synthesize([], _, _, ores), do: ores

  defp synthesize([{"ORE", ore} | todo], look_up_table, leftovers, ores) do
    synthesize(todo, look_up_table, leftovers, ores + ore)
  end

  defp synthesize([{identifier, amount} | todo], look_up_table, leftovers, ores) do
    chemical = look_up_table[identifier]
    leftover = leftovers[identifier] || 0
    multiplier = ceil((amount - leftover) / chemical.increment)

    synthesize(
      Enum.concat(
        for(
          {next_c, input_amount} <- chemical.inputs,
          do: {next_c, input_amount * multiplier}
        ),
        todo
      ),
      look_up_table,
      Map.put(
        leftovers,
        identifier,
        multiplier * chemical.increment + leftover - amount
      ),
      ores
    )
  end

  defp parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn reaction, look_up_table ->
      [inputs, output] = String.split(reaction, " => ", trim: true)
      [output_amount, output_chemical] = String.split(output, " ")

      inputs =
        String.split(inputs, ", ")
        |> Enum.reduce(Map.new(), fn input, acc ->
          [num, chemical] = String.split(input, " ")

          Map.put(acc, chemical, String.to_integer(num))
        end)

      Map.put(look_up_table, output_chemical, %{
        increment: String.to_integer(output_amount),
        inputs: inputs
      })
    end)
  end
end
