defmodule Day04 do
  @neighbours -1..1
              |> Enum.flat_map(fn j -> for i <- -1..1, do: {i, j} end)
              |> Enum.reject(&(&1 == {0, 0}))

  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.trim()
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn
        {".", x} -> {{x, y}, :none}
        {"@", x} -> {{x, y}, :roll}
      end)
    end)
    |> Map.new()
  end

  def part1(map) do
    map
    |> reachable_rolls()
    |> Enum.count()
  end

  def reachable_rolls(map) do
    map
    |> Enum.filter(fn {_, v} -> v == :roll end)
    |> Enum.map(fn {{x, y}, _} -> {{x, y}, count_free_neighbours(map, x, y)} end)
    |> Enum.filter(fn {_, n} -> n >= 5 end)
  end

  def count_free_neighbours(map, x, y) do
    @neighbours
    |> Enum.filter(fn {dx, dy} -> free?(map, x + dx, y + dy) end)
    |> Enum.count()
  end

  def free?(map, x, y), do: map[{x, y}] in [nil, :none]

  def part2(tile_map) do
    Stream.unfold(tile_map, &remove_rolls/1)
    |> Enum.sum()
  end

  def remove_rolls(tile_map) do
    reachable =
      tile_map
      |> reachable_rolls()

    count = length(reachable)

    new_map =
      tile_map
      |> Map.merge(Map.new(reachable, fn {k, _} -> {k, :none} end))

    case count do
      0 -> nil
      _ -> {count, new_map}
    end
  end
end
