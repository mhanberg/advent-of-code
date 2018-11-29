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

  def gen_a_2(val) do
    a = gen_a(val)
    case rem(a, 4) do
      0 -> a
      _ -> gen_a_2(a)
    end
  end

  def gen_b_2(val) do
    b = gen_b(val)
    case rem(b, 8) do
      0 -> b
      _ -> gen_b_2(b)
    end
  end

  def compare(a, b) do
    a = String.slice(a, -16, 16)
    b = String.slice(b, -16, 16)

    a == b
  end
end

{ans, _a, _b} =
  1..40_000_000
  |> Enum.reduce({0, 591, 393}, fn(_x, {acc, next_a, next_b}) ->
    a = Day15.gen_a(next_a)
    bin_a = a |> Integer.to_charlist(2) |> to_string

    b = Day15.gen_b(next_b)
    bin_b = b |> Integer.to_charlist(2) |> to_string

    eq = Day15.compare(bin_a, bin_b)

    case eq do
      true -> {acc + 1, a, b}
      false -> {acc, a, b}
    end
end)

IO.inspect ans

{ans, _a, _b} =
  1..5_000_000
  |> Enum.reduce({0, 591, 393}, fn(_x, {acc, next_a, next_b}) ->
    a = Day15.gen_a_2(next_a)
    bin_a = a |> Integer.to_charlist(2) |> to_string

    b = Day15.gen_b_2(next_b)
    bin_b = b |> Integer.to_charlist(2) |> to_string

    eq = Day15.compare(bin_a, bin_b)

    case eq do
      true -> {acc + 1, a, b}
      false -> {acc, a, b}
    end
end)

IO.inspect ans
