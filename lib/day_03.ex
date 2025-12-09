defmodule Day03 do
  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(
      &(String.trim(&1)
        |> String.graphemes()
        |> Enum.map(fn s -> String.to_integer(s) end))
    )
  end

  def p1_maximum_joltage(bank) do
    indexed = bank |> Enum.zip(0..length(bank))

    {first, first_idx} =
      indexed
      |> Enum.take(length(bank) - 1)
      |> Enum.max_by(&elem(&1, 0))

    second =
      bank
      |> Enum.drop(first_idx + 1)
      |> Enum.max()

    first * 10 + second
  end

  def part1(banks) do
    banks
    |> Enum.map(&p1_maximum_joltage/1)
    |> Enum.sum()
  end

  def p2_maximum_joltage(bank) do
    indexed = bank |> Enum.zip(0..length(bank))

    11..0//-1
    |> Enum.scan(0, fn margin_right, margin_left ->
      {_, index} =
        indexed
        |> Enum.drop(margin_left)
        |> Enum.take(length(indexed) - margin_right - margin_left)
        |> Enum.max_by(fn {value, _} -> value end)

      index + 1
    end)
    |> Enum.zip(11..0//-1)
    |> Enum.map(fn {index, power} -> Integer.pow(10, power) * Enum.at(bank, index - 1) end)
    |> Enum.sum()
  end

  def part2(banks) do
    banks
    |> Enum.map(&p2_maximum_joltage/1)
    |> Enum.sum()
  end
end
