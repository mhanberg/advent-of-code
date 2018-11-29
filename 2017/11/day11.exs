{x, y, z, max} =
  # File.read!("day11_input.txt")
  File.read!("day11_input.txt")
  |> String.trim
  |> String.split(",")
  |> Enum.reduce({0, 0, 0, 0}, fn(dir, {x, y, z, max}) ->
    {x, y, z} =
      case dir do
        "n" -> {x, y + 1, z - 1}
        "ne" -> {x + 1, y, z - 1}
        "se" -> {x + 1, y - 1, z}
        "sw" -> {x - 1, y, z + 1}
        "nw" -> {x - 1, y + 1, z}
        "s" -> {x, y - 1, z + 1}
      end
    max = Enum.max([abs(x), abs(y), abs(z), max])
    {x, y, z, max}
  end)

# Part 1
IO.inspect Enum.max([abs(x), abs(y), abs(z)])
# Part 2
IO.inspect max
