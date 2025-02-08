defmodule Square do
  defstruct [
    :owner,
    :x_value,
    :y_value,
    :is_winner,
    :quarter_won
  ]

  def get_square(%Board{squares: squares}, x_value, y_value) do
    squares
    |> List.flatten()
    |> Enum.find(fn square ->
      x_value == square.x_value and y_value == square.y_value
    end)
  end

  def can_update_square?(%Board{} = board, x_value, y_value, user, score_start_time) do
    square = __MODULE__.get_square(board, x_value, y_value)
    time_now = DateTime.utc_now() |> DateTime.from_unix(:millisecond)

    cond do
      is_nil(square) ->{:error, "Square does not exist"}
      square.user && (square.user != user) -> {:error, "Only the existing user can update the square"}
      time_now > score_start_time -> {:error, "The game has already started"}
      true -> true
    end
  end

  def update_square_owner(board, x_value, y_value, user) do
    key = :owner
    __MODULE__.update_square(board, x_value, y_value, key, user)
  end

  def remove_user(%Board{} = board, x_value, y_value) do
    key = :owner
    update_square(board, x_value, y_value, key, "")
  end

  def update_winning_square(%Board{} = board, %Score{} = score) do
    home_score = score.home_score |> Integer.digits() |> List.last()
    away_score = score.away_score |> Integer.digits() |> List.last()

    # How can we update both of these at the same time?
    key = :is_winner
    value = true
    updated_board = __MODULE__.update_square(board, home_score, away_score, key, value)

    key = :quarter_won
    value = score.current_quarter
    __MODULE__.update_square(updated_board, home_score, away_score, key, value)
  end

  def update_square(%Board{squares: squares}, x_value, y_value, key, value) do
    count = Enum.at(squares, 0) |> Enum.count()

    updated_squares =
      squares
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
