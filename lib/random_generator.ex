defmodule RandomGenerator do
  def generate_unique_numbers(n \\ 10) do
    Enum.shuffle(0..n)
  end
end
