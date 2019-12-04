defmodule AdventOfCode2019.Day04 do
  def part1(passwords) do
    check(passwords, fn password ->
      repeating(password) && never_decrease(password)
    end)
  end

  def part2(passwords) do
    check(passwords, fn password ->
      at_least_one_dub(password) && never_decrease(password)
    end)
  end

  defp repeating(password) do
    Enum.dedup(password) != password
  end

  defp never_decrease([first, second, third, fourth, fifth, sixth]) do
    first <= second and second <= third and third <= fourth and fourth <= fifth and fifth <= sixth
  end

  defp at_least_one_dub([first | rest]) do
    Enum.reduce(rest, [{first, 1}], fn digit, [{h, count} | rest] = counter ->
      if digit == h do
        [{h, count + 1} | rest]
      else
        [{digit, 1} | counter]
      end
    end)
    |> Enum.any?(fn {_, count} -> count == 2 end)
  end

  def check(passwords, checker) do
    for password <- passwords, reduce: 0 do
      count ->
        if checker.(Integer.digits(password)) do
          count + 1
        else
          count
        end
    end
  end
end
