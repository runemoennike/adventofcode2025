defmodule Day02 do
  def parse(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn str ->
      String.split(str, "-") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
  end

  def p1_repeating?(s) do
    len = String.length(s)

    if len >= 2 do
      s == s |> String.slice(0, Integer.floor_div(len, 2)) |> String.duplicate(2)
    else
      false
    end
  end

  def part1(id_ranges) do
    id_ranges
    |> Enum.map(fn {a, b} -> a..b end)
    |> Enum.concat()
    |> Enum.filter(&p1_repeating?(Integer.to_string(&1)))
    |> Enum.sum()
  end

  def p2_repeating?(s) do
    len = String.length(s)

    if len >= 2 do
      1..Integer.floor_div(len, 2)
      |> Enum.map(fn c ->
        s |> String.slice(0, c) |> String.duplicate(Integer.floor_div(len, c))
      end)
      |> Enum.filter(&(&1 == s))
      |> Enum.any?()
    else
      false
    end
  end

  def part2(id_ranges) do
    id_ranges
    |> Enum.map(fn {a, b} -> a..b end)
    |> Enum.concat()
    |> Enum.filter(&p2_repeating?(Integer.to_string(&1)))
    |> Enum.sum()
  end
end
