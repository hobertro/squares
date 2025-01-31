defmodule Game do
  defstruct [
    :home_team,
    :away_team,
    :home_team_current_score,
    :away_team_current_score,
    :current_quarter,
    :metadata,
    :game_id
  ]
  def assign_current_winner(board, game) do
    home_team = board.x_value_team
    away_team = board.y_value_team


    board.squares
    |> Enum.flatten()
    |> Enum.find(fn square ->
        square[:x_value] == game.home_team_current_score && square[:y_value] == game.away_team_current_score
    end)
  end
end
