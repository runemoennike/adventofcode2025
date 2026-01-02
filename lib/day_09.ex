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
    |> Enum.find(fn {_area, a, b} -> not rect_crosses(a, b, edges) end)
    |> then(&elem(&1, 0))
  end

  def rect_crosses({ax, ay}, {bx, by}, edges) do
    rect_lines = [
      [{ax, ay}, {bx, ay}],
      [{bx, ay}, {bx, by}],
      [{bx, by}, {ax, by}],
      [{ax, by}, {ax, ay}]
    ]

    edges
    |> Enum.any?(fn edge ->
      rect_lines |> Enum.any?(fn rect_line -> aa_lines_cross(rect_line, edge) end)
    end)
  end

  def aa_lines_cross([{mx1, my1}, {mx2, my2}], [{nx1, ny1}, {nx2, ny2}])
      when mx1 == nx1 and my1 == ny1
      when mx1 == nx2 and my1 == ny2
      when mx2 == nx1 and my2 == ny1
      when mx2 == nx2 and my2 == ny2
      when mx1 == nx1 and my1 == ny1 and mx2 == nx2 and my2 == ny2
      when mx1 == nx2 and my1 == ny2 and mx2 == nx1 and my2 == ny1,
      do: false

  def aa_lines_cross([{mx1, my1}, {mx2, my2}], [{nx1, ny1}, {nx2, ny2}]) do
    m_vertical = mx1 == mx2
    n_vertical = nx1 == nx2

    cond do
      m_vertical and not n_vertical ->
        mx1 > min(nx1, nx2) and mx1 < max(nx1, nx2) and
          ny1 > min(my1, my2) and ny1 < max(my1, my2)

      not m_vertical and n_vertical ->
        nx1 > min(mx1, mx2) and nx1 < max(mx1, mx2) and
          my1 > min(ny1, ny2) and my1 < max(ny1, ny2)

      true ->
        false
    end
  end

  def vertices_to_edges(positions) do
    (positions ++ [hd(positions)]) |> Enum.chunk_every(2, 1, :discard)
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
