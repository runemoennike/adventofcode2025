defmodule Day09 do
  use Memoize

  @directions [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]

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
    lookup = points |> compress()
    map = lookup |> generate_map |> rasterise_edges(edges, lookup) |> fill

    points
    |> build_areas()
    |> Enum.sort_by(&elem(&1, 0), :desc)
    |> Enum.map(fn {area, a, b} -> {area, encode(a, lookup), encode(b, lookup)} end)
    |> Enum.find(fn {_area, a, b} -> !is_oob(rect_edges(a, b), map) end)
    |> then(fn {area, _a, _b} -> area end)
  end

  def is_oob([], _map), do: false
  def is_oob([h | t], map), do: is_oob(h, map) or is_oob(t, map)

  def is_oob({x, y}, map) when is_integer(x) and is_integer(y),
    do: get_in(map, [Access.at(y), Access.at(x)]) == 0

  def is_oob({{ax, ay} = a, {bx, by} = b}, map) do
    is_oob({ax, by}, map) or is_oob({bx, ay}, map) or
      get_edge_coordinates(a, b)
      |> Enum.any?(fn {x, y} ->
        is_oob({x, y}, map)
      end)
  end

  def get_edge_coordinates({x, y1}, {x, y2}) when y1 <= y2, do: for(y <- y1..y2//1, do: {x, y})
  def get_edge_coordinates({x, y1}, {x, y2}) when y1 > y2, do: for(y <- y2..y1//1, do: {x, y})
  def get_edge_coordinates({x1, y}, {x2, y}) when x1 <= x2, do: for(x <- x1..x2//1, do: {x, y})
  def get_edge_coordinates({x1, y}, {x2, y}) when x1 > x2, do: for(x <- x2..x1//1, do: {x, y})

  def get_edge_coordinates({_x1, _y1}, {_x2, _y2}), do: raise("Can only do rectilinear lines.")

  def print_map(map) do
    map
    |> tap(
      &Enum.each(&1, fn line ->
        line
        |> Enum.each(fn
          0 -> IO.write(".")
          1 -> IO.write("#")
        end)

        IO.puts("")
      end)
    )
  end

  def fill(map) do
    x = Integer.floor_div(length(hd(map)), 2)

    for(
      y <- Integer.floor_div(length(map), 2)..0//-1,
      get_in(map, [Access.at(y), Access.at(x)]) == 0,
      do: y
    )
    |> Enum.reduce_while(map, fn y, map ->
      case flood(map, x, y) do
        {:ok, filled_map} -> {:halt, filled_map}
        {:fail, _} -> {:cont, map}
      end
    end)
  end

  defp flood(map, x, y) do
    cond do
      x < 0 or y < 0 or y >= length(map) or x >= length(hd(map)) ->
        {:fail, nil}

      map |> Enum.at(y) |> Enum.at(x) == 1 ->
        {:ok, map}

      true ->
        map
        |> update_in([Access.at(y), Access.at(x)], fn _ -> 1 end)
        |> then(fn map ->
          Enum.reduce(@directions, {:ok, map}, fn {dx, dy}, {status, cur_map} ->
            case flood(cur_map, x + dx, y + dy) do
              {:fail, next_map} -> {:fail, next_map}
              {:ok, next_map} -> {status, next_map}
            end
          end)
        end)
    end
  end

  def rasterise_edges(map, edges, lookup) do
    edges
    |> encode(lookup)
    |> Enum.reduce(map, fn edge, map -> rasterise_edge(map, edge) end)
  end

  def rasterise_edge(map, {{x, y1}, {x, y2}}) do
    ya = min(y1, y2)
    yb = max(y1, y2)

    map
    |> Enum.with_index()
    |> Enum.map(fn
      {_v, y} when y in ya..yb//1 -> map |> Enum.at(y) |> List.replace_at(x, 1)
      {v, _y} -> v
    end)
  end

  def rasterise_edge(map, {{x1, y}, {x2, y}}) do
    xa = min(x1, x2)
    xb = max(x1, x2)

    map
    |> List.replace_at(
      y,
      map
      |> Enum.at(y)
      |> Enum.with_index()
      |> Enum.map(fn
        {_v, x} when x in xa..xb//1 -> 1
        {v, _x} -> v
      end)
    )
  end

  def rasterise_edge(_map, {{_x1, _y1}, {_x2, _y2}}),
    do: raise("Can only rasterise rectilinear lines.")

  def generate_map(lookup) do
    # Row major order, i.e. map[y][x]
    0 |> List.duplicate(map_size(lookup.x)) |> List.duplicate(map_size(lookup.y))
  end

  def encode([], _lookup), do: []
  def encode([head | tail], lookup), do: [encode(head, lookup) | encode(tail, lookup)]
  def encode({{_, _} = a, {_, _} = b}, lookup), do: {encode(a, lookup), encode(b, lookup)}
  def encode({x, y}, lookup), do: {lookup.x_rev[x], lookup.y_rev[y]}

  def compress(points) do
    points
    |> Enum.unzip()
    |> then(fn {xs, ys} ->
      x = xs |> Enum.sort() |> Enum.dedup()
      y = ys |> Enum.sort() |> Enum.dedup()

      %{
        x: x |> Enum.with_index() |> Map.new(fn {v, idx} -> {idx, v} end),
        y: y |> Enum.with_index() |> Map.new(fn {v, idx} -> {idx, v} end),
        x_rev: x |> Enum.with_index() |> Map.new(),
        y_rev: y |> Enum.with_index() |> Map.new(),
        valid_x: MapSet.new(x),
        valid_y: MapSet.new(y)
      }
    end)
  end

  def rect_edges({ax, ay}, {bx, by}) do
    [
      # {{ax, ay}, {bx, ay}},
      {{bx, ay}, {bx, by}},
      # {{bx, by}, {ax, by}},
      {{ax, by}, {ax, ay}}
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
