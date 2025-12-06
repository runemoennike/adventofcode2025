defmodule Day01 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.trim(&1) |> String.split_at(1)))
    |> Enum.map(fn
      {"L", n} -> -String.to_integer(n)
      {"R", n} -> String.to_integer(n)
    end)
  end

  defp zero_score(0, zeroes), do: zeroes + 1
  defp zero_score(_, zeroes), do: zeroes

  def part1(steps) do
    steps
    |> List.foldl({50, 0}, fn step, {position, zeroes} ->
      new_position = Integer.mod(position + step, 100)
      {new_position, zero_score(new_position, zeroes)}
    end)
    |> elem(1)
  end
end
