defmodule Board do
  @moduledoc """
  Documentation for `Board`.
  """

  @doc """
  - This function generates a 10 by 10 grid
  - Each "row" contains a list of 10 maps, each containing an owner, x and y value
  - The x value stands for the value that be in each map in that row
  - The y value stands for the value that will be in each map of that column
  """

  defstruct [
    :squares,
    :current_winning_x_value,
    :current_winning_y_value,
    :x_value_team,
    :y_value_team,
    :game_id
  ]

  @spec generate_board(number()) :: %Board{
          current_winning_x_value: nil,
          current_winning_y_value: nil,
          squares: any()
        }
  @spec generate_board() :: %Board{
          current_winning_x_value: nil,
          current_winning_y_value: nil,
          squares: any()
        }
  def generate_board(num_squares \\ 10) do
    generate_squares(num_squares)
    |> generate_row_values()
    |> generate_column_values()
  end

  def generate_squares(num \\ 10) do
    # we need to generate a 10 by 10 grid
    # 10 arrays, each with 10 hashes with x,y, and owner values

    # How would you do this with a for loop?
    squares =
      Enum.reduce(1..num, [], fn _num, acc ->
        row =
          Enum.reduce(1..num, [], fn _inner_num, inner_acc ->
            [%Square{owner: "", x_value: "", y_value: ""} | inner_acc]
          end)

        [row | acc]
      end)

    %Board{squares: squares}
  end

  @doc """
  - This function will generate a list of random generated numbers that will represent the X value of each row
  - Iterate over each list, and add the number corresponding to the index on the list of random numbers to the numbered row
  - So for "Row 1", or the first list, add the number at index 0 of list_of_random_numbers, as its X value
  """

  def generate_row_values(%Board{squares: squares}) do
    list_of_random_numbers = RandomGenerator.generate_unique_numbers(10)
    squares_with_index = squares |> Enum.with_index()

    squares =
      Enum.reduce(squares_with_index, [], fn {row, index}, acc ->
        new_row =
          Enum.reduce(row, [], fn map, inner_acc ->
            value = Enum.at(list_of_random_numbers, index)
            [Map.put(map, :x_value, value) | inner_acc]
          end)

        [new_row | acc]
      end)

    %Board{squares: squares}
  end

  @spec generate_column_values(any()) :: any()
  def generate_column_values(%Board{squares: squares}) do
    list_of_random_numbers = RandomGenerator.generate_unique_numbers(10)

    squares =
      Enum.reduce(squares, [], fn row, acc ->
        row_with_index = row |> Enum.with_index()

        new_row =
          Enum.reduce(row_with_index, [], fn {map, index}, inner_acc ->
            value = Enum.at(list_of_random_numbers, index)
            [Map.put(map, :y_value, value) | inner_acc]
          end)

        [new_row | acc]
      end)

    %Board{squares: squares}
  end
end
