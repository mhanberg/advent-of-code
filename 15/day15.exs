defmodule Day15 do
  @a_factor 16807
  @b_factor 48271

  @mod 2147483647

  def gen_a(val) do
    rem(val * @a_factor, @mod)
  end

  def gen_b(val) do
    rem(val * @b_factor, @mod)
  end

  def compare(a, b) do
    a = String.slice(a, -16, 16)
    b = String.slice(b, -16, 16)

    a == b
  end
end

{ans, _a, _b} =
  1..40_000_000
  |> Enum.reduce({0, 591, 393}, fn(x, {acc, next_a, next_b}) ->
    a = Day15.gen_a(next_a)
    bin_a = a |> Integer.to_charlist(2) |> to_string |> String.pad_leading(32, "0")

    b = Day15.gen_b(next_b)
    bin_b = b |> Integer.to_charlist(2) |> to_string |> String.pad_leading(32, "0")

    eq = Day15.compare(bin_a, bin_b)

    case eq do
      true -> {acc + 1, a, b}
      false -> {acc, a, b}
    end
end)

IO.inspect ans
