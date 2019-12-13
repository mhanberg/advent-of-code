defmodule AdventOfCode2019.Day13 do
  alias __MODULE__.Arcade
  import IO.ANSI

  def part1(args) do
    program = Vm.parse(args)

    {:ok, _} = Vm.start_link(:e, program, [], [], self(), self())

    await(Arcade.new())
  end

  def part2(args) do
    program = Vm.parse(args)

    {:ok, _} = Vm.start_link(:e, program, [], [], self(), self())

    IO.write(clear())

    await(Arcade.new())
  end

  defp await(arcade) do
    receive do
      {:add_inputs, [input]} ->
        await(Arcade.input(arcade, input))

      {:request_input, pid} ->
        Arcade.draw_board(arcade)

        send(pid, {:add_inputs, artifical_intelligence(arcade)})

        await(arcade)

      _ ->
        GenServer.stop(:e)

        arcade.score
    end
  end

  defp artifical_intelligence(arcade) do
    [{bx, _} | _] = arcade.ball_locations

    {px, _} = arcade.paddle_location

    cond do
      bx < px -> -1
      bx > px -> 1
      bx == px -> 0
    end
  end

  defmodule Arcade do
    defstruct instructions: [], board: %{}, score: 0, ball_locations: [], paddle_location: nil

    def new, do: %__MODULE__{}

    def input(%__MODULE__{instructions: [0, -1]} = arcade, score) do
      struct(
        arcade,
        instructions: [],
        score: score
      )
    end

    def input(%__MODULE__{instructions: [y, x]} = arcade, tile_id) do
      ball_locations =
        if tile_id == 4 do
          [{x, y} | arcade.ball_locations]
        else
          arcade.ball_locations
        end

      paddle_location =
        if tile_id == 3 do
          {x, y}
        else
          arcade.paddle_location
        end

      struct(
        arcade,
        instructions: [],
        ball_locations: ball_locations,
        paddle_location: paddle_location,
        board: Map.put(arcade.board, {x, y}, tile_id)
      )
    end

    def input(%__MODULE__{instructions: instructions} = arcade, input) do
      struct(arcade, instructions: [input | instructions])
    end

    def draw_board(%__MODULE__{board: board, score: score}) do
      {_, max_y} = Map.keys(board) |> Enum.max_by(fn {_, y} -> y end)
      {max_x, _} = Map.keys(board) |> Enum.max_by(fn {x, _} -> x end)

      IO.write(
        cursor(0, 0) <>
          for y <- 0..max_y, into: "" do
            "\r" <>
              for x <- 0..max_x, into: "" do
                tile = tile(board[{x, y}] || 0)

                tile
              end <>
              "\n"
          end <> "\n" <> cyan_background() <> to_string(score) <> reset() <> "\n"
      )
    end

    defp tile(0), do: white_background() <> " " <> reset()
    defp tile(1), do: green_background() <> " " <> reset()
    defp tile(2), do: yellow_background() <> " " <> reset()
    defp tile(3), do: black_background() <> " " <> reset()
    defp tile(4), do: red_background() <> " " <> reset()
  end
end
