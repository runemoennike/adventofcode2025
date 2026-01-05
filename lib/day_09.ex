defmodule Day09 do
  use Memoize

  def parse(input) do
    input
    |> String.split(["\n", "\r\n"], trim: true)
    |> Enum.map(fn l ->
      l
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def part1(points) do
    points
    |> build_areas()
    |> Enum.map(&elem(&1, 0))
    |> Enum.max()
  end

  def part2(points) do
    edges = points |> polygon_edges()
    lookup = points |> compress |> IO.inspect()
    map = lookup |> generate_map |> rasterise_edges(edges, lookup) |> IO.inspect()
  end

  def rasterise_edges(map, edges, lookup) do
    edges |> encode(lookup) |> Enum.reduce(map, fn edge, map -> rasterise_edge(map, edge) end)
  end

  def rasterise_edge(map, {{x, y1}, {x, y2}}) do
    map
    |> Enum.with_index()
    |> Enum.map(fn
      {_v, y} when y in y1..y2//1 -> map |> Enum.at(y) |> List.replace_at(x, 1)
      {v, _y} -> v
    end)
  end

  def rasterise_edge(map, {{x1, y}, {x2, y}}) do
    map
    |> List.replace_at(
      y,
      map
      |> Enum.at(y)
      |> Enum.with_index()
      |> Enum.map(fn
        {_v, x} when x in x1..x2//1 -> 1
        {v, _x} -> v
      end)
    )
  end

  def rasterise_edge(_map, {{_x1, _y1}, {_x2, _y2}}),
    do: raise("Can only rasterise horizontal and vertical edges.")

  def generate_map(lookup) do
    # Row major order, i.e. map[y][x]
    0 |> List.duplicate(length(lookup.x)) |> List.duplicate(length(lookup.y))
  end

  def encode([head | tail]), do: [encode(head) | encode(tail)]
  def encode({{_, _} = a, {_, _} = b}), do: {encode(a), encode(b)}
  def encode({x, y}, lookup), do: {lookup.x[x], lookup.y[y]}

  def compress(points) do
    points
    |> Enum.unzip()
    |> then(fn {xs, ys} ->
      x = xs |> Enum.sort() |> Enum.dedup()
      y = ys |> Enum.sort() |> Enum.dedup()

      %{
        x: x,
        y: y,
        x_rev: x |> Enum.with_index() |> Map.new(),
        y_rev: y |> Enum.with_index() |> Map.new()
      }
    end)
  end

  def rect_edges({ax, ay}, {bx, by}) do
    [
      {{ax, ay}, {bx, ay}},
      {{bx, ay}, {bx, by}},
      {{bx, by}, {bx, ay}},
      {{bx, ay}, {ax, ay}}
    ]
  end

  def polygon_edges(points) do
    points |> Enum.zip(Enum.drop(points, 1) ++ [hd(points)])
  end

  def build_areas(positions) do
    positions
    |> Enum.flat_map(fn pos -> build_areas(pos, positions) end)
  end

  def build_areas(pos, positions) do
    positions
    |> Enum.take_while(&(&1 != pos))
    |> Enum.map(fn pos_b -> {inclusive_area(pos, pos_b), pos, pos_b} end)
  end

  def inclusive_area({ax, ay}, {bx, by}) do
    (abs(bx - ax) + 1) * (abs(by - ay) + 1)
  end
end
