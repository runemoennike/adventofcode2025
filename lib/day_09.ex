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
    lookup = points |> compress
    map = lookup |> generate_map |> rasterise_edges(edges)
  end

  def rasterise_edges(map, edges) do
    edges |> Enum.reduce(map, &rasterise_edge/2)
  end

  def rasterise_edge(map, {{x, y1}, {x, y2}}) do
    for y <- min(y1, y2)..max(y1..y2), do: y
      |> Enum.reduce(map, fn y, map -> map
  end

  def rasterise_edge(map, {{x1, y}, {x2, y}}) do
    nil
  end

  def rasterise_edge(_map, {{_x1, _y1}, {_x2, _y2}}),
    do: raise("Can only rasterise horizontal and vertical edges.")

  def generate_map(lookup) do
    # Row first order
    0 |> List.duplicate(length(lookup.x)) |> List.duplicate(length(lookup.y))
  end

  def compress(points) do
    points
    |> Enum.unzip()
    |> then(fn {xs, ys} ->
      %{
        x: xs |> Enum.sort() |> Enum.dedup(),
        y: ys |> Enum.sort() |> Enum.dedup()
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
    points |> Enum.zip(points.drop(1) ++ [hd(points)])
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
