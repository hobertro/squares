defmodule Square do
  defstruct [
    :owner,
    :x_value,
    :y_value,
    :is_winner,
    :quarter_won
  ]

  def update_square_owner(board, x_value, y_value, user) do
    key = :owner
    __MODULE__.update_square(board, x_value, y_value, key, user)
  end

  def update_winning_square(%Board{} = board, %Score{} = score) do
    home_score = score.home_score |> Integer.digits |> List.last
    away_score = score.away_score |> Integer.digits |> List.last

    key = :is_winner
    value = true
    updated_board = __MODULE__.update_square(board, home_score, away_score, key, value)

    key = :quarter_won
    value = score.current_quarter
    __MODULE__.update_square(updated_board, home_score, away_score, key, value)
  end

  def update_square(%Board{squares: squares}, x_value, y_value, key, value) do
    count = Enum.at(squares, 0) |> Enum.count
    updated_squares = squares
    |> List.flatten()
    |> Enum.map(fn square ->
      if x_value == square.x_value and y_value == square.y_value do
        Map.put(square, key, value)
      else
        square
      end
    end)
    |> Enum.chunk_every(count)

    %Board{squares: updated_squares}
  end
end
