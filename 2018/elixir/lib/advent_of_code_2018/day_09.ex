defmodule AdventOfCode2018.Day09 do
  defdelegate part2(input), to: __MODULE__, as: :part1

  def part1({players, last_marble_worth}) do
    1..players
    |> Stream.cycle()
    |> Enum.take(last_marble_worth)
    |> Enum.reduce(
      %{
        player_scores: Enum.reduce(1..players, Map.new(), &Map.put(&2, &1, 0)),
        marbles: [0],
        current_marble: 1
      },
      fn player,
         %{player_scores: player_scores, marbles: marbles, current_marble: current_marble} ->
        if rem(current_marble, 23) == 0 do
          [removed_marble | marbles] = rotate(marbles, 7)

          player_scores =
            Map.update!(player_scores, player, &(&1 + current_marble + removed_marble))

          %{
            player_scores: player_scores,
            marbles: rotate(marbles, -1),
            current_marble: current_marble + 1
          }
        else
          marbles = [current_marble | rotate(marbles, -1)]

          %{
            player_scores: player_scores,
            marbles: marbles,
            current_marble: current_marble + 1
          }
        end
      end
    )
    |> Map.fetch!(:player_scores)
    |> Enum.max_by(fn {_p, s} -> s end)
    |> elem(1)
  end

  defp rotate(list, num) do
    {head, tail} = Enum.split(list, num)

    tail ++ head
  end
end
