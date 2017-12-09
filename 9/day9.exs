input = File.read!("day9_input.txt")
  |> String.replace_trailing("\n", "")
  |> String.graphemes

Part 1
{l, _t} = input
  |> Enum.reduce([], fn(x, acc) ->
      case List.last(acc) do
        "!" -> acc ++ [nil]
        _ -> acc ++ [x]
      end
    end)
  |> Enum.reject(&(is_nil(&1)))
  |> Enum.reject(&(&1 == "!"))
  |> Enum.reduce({[], :keep}, fn(x, {acc, keep?}) ->
      case keep? do
        :keep when x != "<" -> {acc ++ [x], :keep}
        :keep when x == "<" -> {acc ++ [x], :drop}
        :drop when x != ">" -> {acc ++ [nil], :drop}
        :drop when x == ">" -> {acc ++ [x], :keep}
        _ -> IO.puts "This shouldn't happen"
      end
    end)

{sum, _i} = l
  |> Enum.reject(&(is_nil(&1)))
  |> Enum.reject(&(&1 == "<"))
  |> Enum.reject(&(&1 == ">"))
  |> Enum.join
  |> String.replace("{,", "{")
  |> String.replace("},}", "}}")
  |> String.replace("},}", "}}")
  |> String.graphemes
  |> Enum.reduce({0, 1}, fn(x, {acc, inc}) ->
      case x do
        "{" -> {acc + inc, inc + 1}
        "}" -> {acc, inc - 1}
        "," -> {acc, inc}
        _ -> {acc, inc}
      end
    end)

sum |> IO.inspect

# Part 2
orig_length = length(input)

{l, _t} = input
  |> Enum.reduce([], fn(x, acc) ->
      case List.last(acc) do
        "!" -> acc ++ ["$"]
        _ -> acc ++ [x]
      end
    end)
  |> Enum.reduce({[], :keep}, fn(x, {acc, keep?}) ->
      case keep? do
        :keep when x == "<" -> {acc ++ [x], :drop}
        :keep when x == "!" -> {acc ++ [x], :keep}
        :keep when x == "$" -> {acc ++ [x], :keep}
        :keep when x != "<" -> {acc ++ [x], :keep}
        :drop when x == ">" -> {acc ++ [x], :keep}
        :drop when x == "!" -> {acc ++ [x], :drop}
        :drop when x == "$" -> {acc ++ [x], :drop}
        :drop when x != ">" -> {acc ++ [nil], :drop}
        _ -> IO.puts "This shouldn't happen"
      end
    end)

new_length = l
  |> Enum.reject(&(is_nil(&1)))
  |> Enum.join
  |> String.replace_trailing("\n", "")
  |> String.length

(orig_length - new_length)
  |> IO.inspect
