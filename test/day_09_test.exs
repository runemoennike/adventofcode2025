defmodule Day09Test do
  use ExUnit.Case, async: true

  import Day09

  setup do
    [
      input: """
      7,1
      11,1
      11,7
      9,7
      9,5
      2,5
      2,3
      7,3
      """
    ]
  end

  test "parse", %{input: input} do
    result = parse(input)

    assert [
             {7, 1},
             {11, 1},
             {11, 7},
             {9, 7},
             {9, 5},
             {2, 5},
             {2, 3},
             {7, 3}
           ] == result
  end

  test "inclusive area" do
    [
      {{10, 10}, {19, 19}, 100},
      {{19, 19}, {10, 10}, 100},
      {{19, 10}, {10, 19}, 100},
      {{10, 19}, {19, 10}, 100},
      {{10, 10}, {10, 10}, 1}
    ]
    |> Enum.each(fn {a, b, area} -> assert inclusive_area(a, b) == area end)
  end

  test "part1 example", %{input: input} do
    result = input |> parse() |> part1()

    assert 50 == result
  end

  test "part1" do
    input = File.read!("./puzzle_input/day_09.txt")

    result = input |> parse() |> part1()

    IO.puts("Part 1: #{result}")
  end

  test "part2 example", %{input: input} do
    result = input |> parse() |> part2()

    assert 24 == result
  end

  # test "part2" do
  #   input = File.read!("./puzzle_input/day_09.txt")
  #
  #   result = input |> parse() |> part2()
  #
  #   IO.puts("Part 2: #{result}")
  # end
end
