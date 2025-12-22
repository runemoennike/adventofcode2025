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

  def maybe_part2({{start_x, 0}, map, {w, h}}) do
    splitters = map |> Map.keys() |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
    mask = Tuple.duplicate(:empty, w) |> then(fn t -> put_elem(t, start_x, :beam) end)

    0..h
    |> Enum.reduce({mask, 0}, fn y, {mask, beam_count} ->
      splitter_xs = splitters[y]

      if splitter_xs == nil do
        {mask, beam_count}
      else
        IO.inspect(splitter_xs)

        splitter_xs
        |> Enum.reduce({mask, beam_count}, fn splitter_x, {mask, beam_count} ->
          if elem(mask, splitter_x) == :beam do
            new_xs =
              [splitter_x - 1, splitter_x + 1]
              |> Enum.filter(&(&1 >= 0 and &1 < w and elem(mask, &1) == :empty))

            updated_mask =
              new_xs
              |> Enum.reduce(mask, fn x, mask -> put_elem(mask, x, :beam) end)
              |> then(fn mask -> put_elem(mask, splitter_x, :empty) end)

            {updated_mask, beam_count + length(new_xs)}
          else
            {mask, beam_count}
          end
        end)
      end
      |> IO.inspect()
    end)
    |> then(&elem(&1, 1))
  end
end
