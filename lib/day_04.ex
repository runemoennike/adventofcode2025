defmodule Day04 do
  @type tile :: :none | :roll
  @type tile_map :: [[tile]]

  @spec parse(String.t()) :: tile_map
  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.trim(&1) |> parse_line))
  end

  @spec parse_line(String.t()) :: [tile]
  def parse_line(line) do
    line
    |> String.graphemes()
    |> Enum.map(fn
      "." -> :none
      "@" -> :roll
    end)
  end

  @spec part1(tile_map) :: pos_integer()
  def part1(map) do
    map
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      line
      |> Enum.with_index()
      |> Enum.map(fn
        {:roll, x} -> count_free_neighbours(map, x, y)
        {:none, _} -> 0
      end)
    end)
    |> Enum.concat()
    |> Enum.filter(&(&1 >= 5))
    |> Enum.count()
  end

  def count_free_neighbours(map, x, y) do
    -1..1
    |> Enum.flat_map(fn j -> for i <- -1..1, do: {i, j} end)
    |> Enum.map(fn {dx, dy} -> free?(map, x + dx, y + dy) end)
    |> Enum.count(& &1)
  end

  def free?(_map, x, y) when x < 0 or y < 0, do: true
  def free?(map, x, y), do: get_in(map, [Access.at(y), Access.at(x)]) in [nil, :none]
end
