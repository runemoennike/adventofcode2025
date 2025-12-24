defmodule Day07 do
  use Memoize

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

  def part1({start, map, map_size}) do
    beam(start, map, map_size)
    |> Enum.uniq()
    |> Enum.count()
  end

  defmemo(
    beam({x, y}, _map, {w, h})
    when x < 0 or y < 0 or x >= w or y >= h,
    do: MapSet.new()
  )

  defmemo beam({x, y}, map, map_size) do
    case map[{x, y}] do
      :split ->
        MapSet.new([{x, y}])
        |> MapSet.union(beam({x - 1, y}, map, map_size))
        |> MapSet.union(beam({x + 1, y}, map, map_size))

      nil ->
        beam({x, y + 1}, map, map_size)
    end
  end

  def part2({{start_x, 0}, map, {w, h}}) do
    splitters = map |> Map.keys() |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
    window = Tuple.duplicate(:empty, w) |> then(fn t -> put_elem(t, start_x, 1) end)

    0..h
    |> Enum.reduce(window, fn y, window ->
      case splitters[y] do
        nil -> window
        xs -> xs |> split(window)
      end
    end)
    |> Tuple.to_list()
    |> Enum.reject(&(&1 == :empty))
    |> Enum.sum()
  end

  def split(xs, window) do
    xs
    |> Enum.reduce(window, fn x, window ->
      case elem(window, x) do
        :empty ->
          window

        n ->
          window
          |> merge_cell(x - 1, n)
          |> merge_cell(x + 1, n)
          |> then(fn mask -> put_elem(mask, x, :empty) end)
      end
    end)
  end

  def merge_cell(mask, x, val) do
    case elem(mask, x) do
      :empty -> put_elem(mask, x, val)
      n -> put_elem(mask, x, n + val)
    end
  end
end
