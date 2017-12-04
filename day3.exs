defmodule Day3 do

  defmodule Part1 do
    @input 368078
    def n(x) when x > 0, do: n(x - 1) + x
    def n(_x), do: 0

    def first(x), do: last(x - 1) + 1

    def last(x), do: 8 * n(x) + 1

    def dist({x, y}), do: abs(x) + abs(y)

    def coordinates(coord, distance, side_length) do
      move(:up, coord, distance, side_length)
    end

    def move(:up, {x, y}, distance, side_length) when distance > side_length do
      c = {x, y + side_length}
      move(:left, c, distance - side_length, side_length)
    end

    def move(:up, {x, y}, distance, _side_length) do
      {x, y + distance}
    end

    def move(:left, {x, y}, distance, side_length) when distance > side_length do
      c = {x - side_length, y}
      move(:down, c, distance - side_length, side_length)
    end

    def move(:left, {x, y}, distance, _side_length) do
      {x - distance, y}
    end

    def move(:down, {x, y}, distance, side_length) when distance > side_length do
      c = {x, y - side_length}
      move(:right, c, distance - side_length, side_length)
    end

    def move(:down, {x, y}, distance, _side_length) do
      {x, y - distance}
    end

    def move(:right, {x, y}, distance, side_length) when distance > side_length do
      {x + side_length, y}
    end

    def move(:right, {x, y}, distance, _side_length) do
      {x + distance, y}
    end

    def part1(x) do
      case last(x) do
        l when l < @input -> part1(x + 1)
        _ -> coordinates({x, -x}, @input - first(x) + 1, x * 2) |> dist
      end
    end
  end

  defmodule Part2 do
    @input 368078

    def move(:right, board, {x, y}, value, 1, squares_to_move) when value < @input do
      new_board = put_in(board[{x + 1, y}], set_square(board, {x + 1, y}))
      move(:up, new_board, {x + 1, y}, new_board[{x + 1, y}], squares_to_move, squares_to_move)
    end

    def move(:right, board, {x, y}, value, squares_left_to_move, squares_to_move) when value < @input do
      new_board = put_in(board[{x + 1, y}], set_square(board, {x + 1, y}))
      move(:right, new_board, {x + 1, y}, new_board[{x + 1, y}], squares_left_to_move - 1, squares_to_move)
    end

    def move(:up, board, {x, y}, value, 1, squares_to_move) when value < @input do
      new_board = put_in(board[{x, y + 1}], set_square(board, {x, y + 1}))
      move(:left, new_board, {x, y + 1}, new_board[{x, y + 1}], squares_to_move + 1, squares_to_move + 1)
    end

    def move(:up, board, {x, y}, value, squares_left_to_move, squares_to_move) when value < @input do
      new_board = put_in(board[{x, y + 1}], set_square(board, {x, y + 1}))
      move(:up, new_board, {x, y + 1}, new_board[{x, y + 1}], squares_left_to_move - 1, squares_to_move)
    end

    def move(:left, board, {x, y}, value, 1, squares_to_move) when value < @input do
      new_board = put_in(board[{x - 1, y}], set_square(board, {x - 1, y}))
      move(:down, new_board, {x - 1, y}, new_board[{x - 1, y}], squares_to_move, squares_to_move)
    end

    def move(:left, board, {x, y}, value, squares_left_to_move, squares_to_move) when value < @input do
      new_board = put_in(board[{x - 1, y}], set_square(board, {x - 1, y}))
      move(:left, new_board, {x - 1, y}, new_board[{x - 1, y}], squares_left_to_move - 1, squares_to_move)
    end

    def move(:down, board, {x, y}, value, 1, squares_to_move) when value < @input do
      new_board = put_in(board[{x, y - 1}], set_square(board, {x, y - 1}))
      move(:right, new_board, {x, y - 1}, new_board[{x, y - 1}], squares_to_move + 1, squares_to_move + 1)
    end

    def move(:down, board, {x, y}, value, squares_left_to_move, squares_to_move) when value < @input do
      new_board = put_in(board[{x, y - 1}], set_square(board, {x, y - 1}))
      move(:down, new_board, {x, y - 1}, new_board[{x, y - 1}], squares_left_to_move - 1, squares_to_move)
    end

    def move(_direction, board, {x, y}, _val, _sq_left_to_move,_sq_to_move), do: {board, board[{x, y}]}

    def set_square(board, {x, y}) do
      square(board, {x + 1, y}) +
      square(board, {x + 1, y + 1}) +
      square(board, {x, y + 1}) +
      square(board, {x - 1, y + 1}) +
      square(board, {x - 1, y}) +
      square(board, {x - 1, y - 1}) +
      square(board, {x, y - 1}) +
      square(board, {x + 1, y - 1})
    end

    def square(board, {x, y}) do
      case board[{x, y}] do
        x when is_integer(x) -> x
        _ -> 0
      end
    end

    def part2() do
      move(:right, %{{0, 0} => 1}, {0, 0}, 1, 1, 1)
    end
  end
end

Day3.Part1.part1(1)
|> IO.inspect

Day3.Part2.part2()
|> IO.inspect
