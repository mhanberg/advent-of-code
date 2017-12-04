File.read!("day4_input.txt")
  |> String.split(~r{\n})
  |> Enum.reduce(0, fn(x, acc) ->
    l = String.split(x)

    case length(l) == length(Enum.uniq(l)) and length(l) > 0 do
      true ->  acc + 1
      _ -> acc
    end
  end)
  |> IO.inspect
