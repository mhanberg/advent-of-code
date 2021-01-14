defmodule Day21 do
  def part1 do
    begins_with = """
    .#.
    ..#
    ###
    """
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" => ")
      |> Enum.map(fn rule ->
        rule
        |> String.split("/")
        |> Enum.map(fn x ->
          x |> String.split("")
        end)
      end)
    end)
    |> IO.inspect

    File.read!("./21/day21_input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [from, to] = line
      |> String.split(" => ")
      |> Enum.map(fn rule ->
        rule
        |> String.split("/")
        |> Enum.map(fn x ->
          x |> String.split("")
        end)
      end)

      %{from: from, to: to}
    end)
  end

  defp rotate(image) do
    image |> List.zip() |> Enum.map(fn row -> row |> Tuple.to_list() |> Enum.reverse() end)
  end

  defp flip_x(image) do
    image |> Enum.map(&Enum.reverse/1)
  end

  defp flip_y(image) do
    image |> rotate() |> rotate() |> flip_x()
  end
  def part2 do
  end
end

Day21.part1() |> IO.inspect()
