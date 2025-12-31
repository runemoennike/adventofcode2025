defmodule Day09 do
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
    positions
    |> build_areas()
    |> Enum.sort_by(&elem(&1, 0), :desc)
    |> IO.inspect()
    |> Enum.find(fn {_area, a, b} -> rect_inside_polygon?(a, b, positions) end)
    |> then(&elem(&1, 0))
  end

  def rect_inside_polygon?({ax, ay} = a, {bx, by} = b, polygon_vertices) do
    IO.puts("")
    IO.inspect({a, b}, label: "Testing ")
    IO.puts("Area = #{inclusive_area(a, b)}")

    [{ax, ay}, {ax, by}, {bx, by}, {bx, ay}]
    |> Enum.all?(&point_inside_polygon?(&1, polygon_vertices))
  end

  def point_inside_polygon?(_, polygon_vertices) when length(polygon_vertices) <= 2,
    do: raise("Not enough vertices to form a polygon")

  def point_inside_polygon?({px, py}, polygon_vertices) do
    IO.inspect({px, py})

    polygon_vertices
    |> Enum.concat([hd(polygon_vertices)])
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(false, fn [{x1, y1}, {x2, y2}], inside ->
      if y1 > py != y2 > py and px < (x2 - x1) * (py - y1) / (y2 - y1) + x1 do
        not inside
      else
        inside
      end
    end)
    |> IO.inspect()
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
