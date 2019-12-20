defmodule Terminal do
  import IO.ANSI, except: [clear: 0]

  def clear(), do: clear(nil)
  def clear(passthrough) do
    IO.write(IO.ANSI.clear())

    passthrough
  end

  def render(pixels, renderer) do
    {{_, min_y}, {_, max_y}} = Map.keys(pixels) |> Enum.min_max_by(fn {_, y} -> y end)
    {{min_x, _}, {max_x, _}} = Map.keys(pixels) |> Enum.min_max_by(fn {x, _} -> x end)

    IO.write(
      cursor(0, 0) <>
        for y <- min_y..max_y, into: "" do
          "\r" <>
            for x <- min_x..max_x, into: "" do
              renderer.(pixels, x, y)
            end <> "\n"
        end
    )

    pixels
  end
end
