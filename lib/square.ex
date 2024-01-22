defmodule Square do
  defstruct [
    :owner,
    :x_value,
    :y_value
  ]

  def mark_square(%Board{squares: squares}, x_value, y_value, user) do
    updated_squares = squares
    |> List.flatten()
    |> Enum.map(fn square ->
      mark_target_square(square, x_value, y_value, user)
    end)
    |> Enum.chunk_every(Enum.count(squares))

    %Board{squares: updated_squares}
  end

  def mark_target_square(square, x_value, y_value, user) do
    case square.owner == "" && square.x_value == x_value && square.y_value == y_value do
      true ->
        %{square | owner: user}
      false ->
        square
    end
  end
end
