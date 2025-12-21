defmodule Day07 do
  def parse(input) do
    h = 1 + (input |> String.trim() |> String.count("\n"))
    w = input |> String.split("\n") |> hd |> String.trim() |> String.length()

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
        {"S", x} -> {{x, y}, :start}
        {"^", x} -> {{x, y}, :split}
        _ -> nil
      end)
    end)
    |> Enum.reject(&(&1 == nil))
    |> Map.new()
    |> then(fn map ->
      {
        map
        |> Enum.find_value(fn
          {coord, :start} -> coord
          _ -> false
        end),
        map |> Map.reject(fn {_, val} -> val == :start end),
        {w, h}
      }
    end)
  end

  def part1({start, map}) do
    w = map |> Map.keys() |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    h = map |> Map.keys() |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    beams(map, {w, h}, start)
    |> Stream.reject(&(&1 == nil))
    |> Stream.uniq()
    |> Enum.sort_by(fn {_x, y} -> y end)
    |> IO.inspect()
    |> Enum.count()
  end

  def beams(_map, {map_w, map_h}, {x, y})
      when x < 0 or x >= map_w or y >= map_h, do: []

  def beams(map, map_size, {x, y}) do
    case map[{x, y}] do
      :split ->
        [{x - 1, y}, {x + 1, y}] ++
          beams(map, map_size, {x - 1, y}) ++ beams(map, map_size, {x + 1, y})

      nil ->
        beams(map, map_size, {x, y + 1})
    end
  end
end
