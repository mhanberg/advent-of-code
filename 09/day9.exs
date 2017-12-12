input = File.read!("day9_input.txt") |> String.replace_trailing("\n", "") |> String.graphemes

l = input
  |> Enum.reduce([], fn(x, acc) ->
      case List.last(acc) do
        "!" -> acc ++ ["$"]
        _ -> acc ++ [x]
      end
    end)

{trimmed_l, _K} = l |> Enum.reduce({[], :keep}, fn(x, {acc, keep?}) ->
      case keep? do
        :keep when x != "<" -> {acc ++ [x], :keep}
        :keep when x == "<" -> {acc ++ [x], :drop}
        :drop when x != ">" -> {acc ++ [nil], :drop}
        :drop when x == ">" -> {acc ++ [x], :keep}
      end
    end)

trimmed_l |> Enum.reduce({0, 1}, fn(x, {acc, inc}) ->
      case x do
        "{" -> {acc + inc, inc + 1}
        "}" -> {acc, inc - 1}
        _ -> {acc, inc}
      end
    end)
  |> IO.inspect

l |> Enum.reduce({[], :keep}, fn(x, {acc, keep?}) ->
      case keep? do
        :keep when x == "<" -> {acc ++ [x], :drop}
        :keep when x == "!" or x == "$" -> {acc ++ [x], :keep}
        :keep when x != "<" -> {acc ++ [x], :keep}
        :drop when x == ">" -> {acc ++ [x], :keep}
        :drop when x == "!" or x == "$" -> {acc ++ [x], :drop}
        :drop when x != ">" -> {acc ++ [nil], :drop}
      end
    end)

(length(input) - (l |> Enum.reject(&(is_nil(&1))) |> Enum.join |> String.length)) |> IO.inspect
