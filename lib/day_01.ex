defmodule Day01 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_one/1)
  end

  def parse_one(step) do
    case step |> String.split_at(1) do
      {"L", t} -> String.to_integer(t) * -1
      {"R", t} -> String.to_integer(t)
    end
  end

  def part1(steps) do
    steps
    |> List.foldl({50, 0}, fn step, {position, zeroes} ->
      new_position = Integer.mod(position + step, 100)

      {
        new_position,
        if new_position == 0 do
          zeroes + 1
        else
          zeroes
        end
      }
    end)
    |> elem(1)
  end
end
