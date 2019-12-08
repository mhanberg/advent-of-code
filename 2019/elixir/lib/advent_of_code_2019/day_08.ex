defmodule AdventOfCode2019.Day08 do
  import IO.ANSI

  def part1({args, wide, tall}) do
    layer =
      args
      |> String.split("", trim: true)
      |> Enum.chunk_every(wide * tall)
      |> Enum.min_by(fn layer -> Enum.count(layer, fn pixel -> pixel == "0" end) end)

    Enum.count(layer, fn pixel -> pixel == "1" end) *
      Enum.count(layer, fn pixel -> pixel == "2" end)
  end

  @whitespace white_background() <> " " <> reset()
  def part2({args, wide, tall}) do
    layers =
      args
      |> String.split("", trim: true)
      |> Enum.chunk_every(wide * tall)
      |> Enum.map(fn layer -> Enum.chunk_every(layer, wide) end)

    for y <- 0..(tall - 1) do
      for x <- 0..(wide - 1) do
        Enum.map(layers, fn layer -> layer |> Enum.at(y) |> Enum.at(x) end)
        |> Enum.find(fn pixel -> pixel != "2" end)
        |> Kernel.==("1")
        |> if(do: @whitespace, else: " ")
        |> IO.write()
      end

      IO.write("\n")
    end
  end
end
