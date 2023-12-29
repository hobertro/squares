defmodule Squares do
  @moduledoc """
  Documentation for `Squares`.
  """

  @doc """
  - This function generates a 10 by 10 grid
  - Each "row" contains a list of 10 maps, each containing an owner, x and y value
  - The x value stands for the value that be in each map in that row
  - The y value stands for the value that will be in each map of that column
  """

  def generate_board() do
    generate_squares()
    |> generate_row_values()
    |> generate_column_values()
  end

  def generate_squares() do
    # we need to generate a 10 by 10 grid
    # 10 arrays, each with 10 hashes with x,y, and owner values
    Enum.reduce(1..10, [], fn _num, acc ->
      row = Enum.reduce(1..10, [], fn _inner_num, inner_acc ->
        [%{owner: "", x: "", y: ""} | inner_acc]
      end)
      [row | acc]
    end)
  end

  @doc """
  - This function will generate a list of random generated numbers that will represent the X value of each row
  - Iterate over each list, and add the number corresponding to the index on the list of random numbers to the numbered row
  - So for "Row 1", or the first list, add the number at index 0 of list_of_random_numbers, as its X value
  """

  def generate_row_values(squares) do
    list_of_random_numbers = RandomGenerator.generate_unique_numbers(10)
    squares_with_index = squares |> Enum.with_index

    Enum.reduce(squares_with_index, [], fn {row, index}, acc ->
      new_row = Enum.reduce(row, [], fn map, inner_acc ->
        value = Enum.at(list_of_random_numbers, index)
        [Map.put(map, :x, value) | inner_acc]
      end)

      [new_row | acc]
    end)
  end

  def generate_column_values(squares) do
    list_of_random_numbers = RandomGenerator.generate_unique_numbers(10)

    Enum.reduce(squares, [], fn row, acc ->
      row_with_index = row |> Enum.with_index()
      new_row = Enum.reduce(row_with_index, [], fn {map, index}, inner_acc ->
        value = Enum.at(list_of_random_numbers, index)
        [Map.put(map, :y, value) | inner_acc]
      end)

      [new_row | acc]
    end)
  end
end
