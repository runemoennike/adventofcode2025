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
    |> Enum.max()
  end

  def build_areas(positions) do
    positions
    |> Enum.flat_map(fn pos -> build_areas(pos, positions) end)
  end

  def build_areas(pos, positions) do
    positions
    |> Enum.take_while(&(&1 != pos))
    |> Enum.map(fn pos_b -> inclusive_area(pos, pos_b) end)
  end

  def inclusive_area({ax, ay}, {bx, by}) do
    (abs(bx - ax) + 1) * (abs(by - ay) + 1)
  end
end
