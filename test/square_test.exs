defmodule SquareTest do
  use ExUnit.Case
  require Square

  test "updating square owner" do
    squares = [
      [
        %Square{x_value: 1, y_value: 1, owner: nil},
        %Square{x_value: 1, y_value: 2, owner: nil},
        %Square{x_value: 1, y_value: 3, owner: nil}
      ],
      [
        %Square{x_value: 2, y_value: 1, owner: nil},
        %Square{x_value: 2, y_value: 2, owner: nil},
        %Square{x_value: 2, y_value: 3, owner: nil}
      ],
      [
        %Square{x_value: 3, y_value: 1, owner: nil},
        %Square{x_value: 3, y_value: 2, owner: nil},
        %Square{x_value: 3, y_value: 3, owner: nil}
      ]
    ]

    x_value = 3
    y_value = 2
    board = %Board{squares: squares}
    user = "bobby"

    assert Square.update_square_owner(board, x_value, y_value, user) == %Board{
             squares: [
               [
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 1, y_value: 1},
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 1, y_value: 2},
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 1, y_value: 3}
               ],
               [
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 2, y_value: 1},
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 2, y_value: 2},
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 2, y_value: 3}
               ],
               [
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 3, y_value: 1},
                 %Square{
                   is_winner: nil,
                   owner: "bobby",
                   quarter_won: nil,
                   x_value: 3,
                   y_value: 2
                 },
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 3, y_value: 3}
               ]
             ]
           }
  end

  test "updating current winning square" do
    squares = [
      [
        %Square{x_value: 1, y_value: 1, owner: nil},
        %Square{x_value: 1, y_value: 2, owner: nil},
        %Square{x_value: 1, y_value: 3, owner: nil}
      ],
      [
        %Square{x_value: 2, y_value: 1, owner: nil},
        %Square{x_value: 2, y_value: 2, owner: nil},
        %Square{x_value: 2, y_value: 3, owner: nil}
      ],
      [
        %Square{x_value: 3, y_value: 1, owner: nil},
        %Square{x_value: 3, y_value: 2, owner: nil},
        %Square{x_value: 3, y_value: 3, owner: nil}
      ]
    ]

    x_value = 2
    y_value = 3
    board = %Board{squares: squares}
    score = %Score{current_quarter: 4, home_score: 22, away_score: 13}

    assert Square.update_winning_square(board, score) == %Board{
             current_winning_x_value: nil,
             current_winning_y_value: nil,
             squares: [
               [
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 1, y_value: 1},
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 1, y_value: 2},
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 1, y_value: 3}
               ],
               [
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 2, y_value: 1},
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 2, y_value: 2},
                 %Square{is_winner: true, owner: nil, quarter_won: 4, x_value: 2, y_value: 3}
               ],
               [
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 3, y_value: 1},
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 3, y_value: 2},
                 %Square{is_winner: nil, owner: nil, quarter_won: nil, x_value: 3, y_value: 3}
               ]
             ]
           }
  end
end
