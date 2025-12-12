defmodule Day05 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.split_while(&(&1 != ""))
    |> then(fn {fresh, available} ->
      {
        fresh
        |> Enum.map(fn s ->
          s
          |> String.split("-")
          |> then(fn [from, to] -> String.to_integer(from)..String.to_integer(to) end)
        end),
        available |> Enum.drop(1) |> Enum.map(&String.to_integer/1)
      }
    end)
  end

  def part1(fresh, available) do
    available
    |> Enum.filter(fn i -> fresh |> Enum.any?(&(i in &1)) end)
    |> Enum.count()
  end

  def part2(fresh) do
    ms = MapSet.new(fresh)

    reduce_ranges(ms)
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
  end

  def reduce_ranges(ranges) do
    ranges
    |> find_overlapping_ranges()
    |> case do
      nil -> ranges
      overlap -> merge_ranges(overlap, ranges) |> reduce_ranges()
    end
  end

  def find_overlapping_ranges(ranges) do
    ranges
    |> Enum.find_value(fn r1 ->
      ranges
      |> Enum.find(fn r2 -> r2 != r1 and not Range.disjoint?(r1, r2) end)
      |> case do
        nil -> false
        r2 -> {r1, r2}
      end
    end)
  end

  def merge_ranges({r1, r2}, ranges) do
    ranges
    |> MapSet.delete(r1)
    |> MapSet.delete(r2)
    |> MapSet.put(min(r1.first, r2.first)..max(r1.last, r2.last))
  end
end
