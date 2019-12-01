defmodule AdventOfCode2019.Day01 do
  def part1(args) do
    args
    |> Enum.map(fn mass ->
      mass
      |> div(3)
      |> Kernel.-(2)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> Enum.map(&calculate_fuel(0, &1))
    |> Enum.sum()
  end

  defp calculate_fuel(fuels, mass) do
    fuel =
      mass
      |> div(3)
      |> Kernel.-(2)

    cond do
      fuel <= 0 ->
        fuels

      true ->
        calculate_fuel(fuels + fuel, fuel)
    end
  end
end
