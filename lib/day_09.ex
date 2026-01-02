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

  def part1(positions) do
    positions
    |> build_areas()
    |> Enum.map(&elem(&1, 0))
    |> Enum.max()
  end

  def part2(positions) do
    edges = vertices_to_edges(positions)

    positions
    |> build_areas()
    |> Enum.sort_by(&elem(&1, 0), :desc)
    |> Enum.find(fn {_area, a, b} -> rect_inside_polygon?(a, b, edges) end)
    |> then(&elem(&1, 0))
  end

  def rect_inside_polygon?({ax, ay}, {bx, by}, polygon_edges) do
    [{ax, ay}, {ax, by}, {bx, by}, {bx, ay}]
    |> Enum.all?(&(point_inside_polygon?(&1, polygon_edges) or point_on_edges(&1, polygon_edges))) and
      []
      |> Enum.all?(&(not line_intersects_polygon(&1, polygon_edges)))
  end

  def line_intersects_polygon({x1, y1, x2, y2}, edges) do
  end

  def vertices_to_edges(vertices) when length(vertices) <= 2,
    do: raise("Not enough vertices to form a polygon")

  def vertices_to_edges(vertices) do
    (vertices ++ [hd(vertices)])
    |> Enum.chunk_every(2, 1, :discard)
  end

  def point_on_edges({px, py}, edges) do
    Enum.any?(edges, fn [{x1, y1}, {x2, y2}] ->
      (px - x1) * (y2 - y1) - (py - y1) * (x2 - x1) == 0 and
        px >= min(x1, x2) and px <= max(x1, x2) and
        py >= min(y1, y2) and py <= max(y1, y2)
    end)
  end

  def point_inside_polygon?({px, py}, edges) do
    Enum.reduce(edges, 0, fn [{x1, y1}, {x2, y2}], hits ->
      if y1 > py != y2 > py do
        intersects? =
          if y2 > y1 do
            (px - x1) * (y2 - y1) < (x2 - x1) * (py - y1)
          else
            (px - x2) * (y1 - y2) < (x1 - x2) * (py - y2)
          end

        if intersects?, do: hits + 1, else: hits
      else
        hits
      end
    end)
    |> Integer.mod(2) != 0
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
