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

  def part1(steps) do
    steps
    |> List.foldl({50, 0}, fn step, {position, zeroes} ->
      new_position = Integer.mod(position + step, 100)
      {new_position, zeroes + if(new_position == 0, do: 1, else: 0)}
    end)
    |> elem(1)
  end
end
