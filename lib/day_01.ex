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

  defp crank(pos, step), do: Integer.mod(pos + step, 100)

  defp zero_score_part1(0), do: 1
  defp zero_score_part1(_), do: 0

  def part1(steps) do
    steps
    |> List.foldl({50, 0}, fn step, {pos, zeroes} ->
      new_pos = crank(pos, step)
      {new_pos, zeroes + zero_score_part1(new_pos)}
    end)
    |> elem(1)
  end

  defp zero_score_part2(pos, step) do
    cond do
      step > 0 -> Integer.floor_div(pos + step, 100)
      step < 0 and pos == 0 -> Integer.floor_div(abs(step), 100)
      step < 0 and crank(pos, step) == 0 -> 1 + Integer.floor_div(abs(step), 100)
      step < 0 -> abs(Integer.floor_div(pos + step, 100))
    end
  end

  def part2(steps) do
    steps
    |> List.foldl({50, 0}, fn step, {pos, zeroes} ->
      # IO.puts("#{position} + #{step} = #{Integer.mod(position + step, 100)} \t +#{zero_score_part2(position, step)}")
      {
        crank(pos, step),
        zeroes + zero_score_part2(pos, step)
      }
    end)
    |> elem(1)
  end
end
