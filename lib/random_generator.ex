defmodule RandomGenerator do
  def generate_unique_numbers(n, acc \\ [])

  def generate_unique_numbers(0, acc), do: acc
  def generate_unique_numbers(n, _acc) when n > 10, do: {:error, "Number cannot be greater than 10"}

  def generate_unique_numbers(n, acc) do
    random_number = Enum.random(0..9)

    case Enum.member?(acc, random_number) do
      true -> generate_unique_numbers(n, acc)
      false -> generate_unique_numbers(n - 1, [random_number | acc])
    end
  end
end
