defmodule Day06Test do
  use ExUnit.Case, async: true

  import Day06

  setup do
    [
      input: """
      123 328  51 64 
       45 64  387 23 
        6 98  215 314
      *   +   *   +  
      """
    ]
  end

  test "part1 parse", %{input: input} do
    result = p1_parse(input)

    assert [
             [:multiply, 123, 45, 6],
             [:add, 328, 64, 98],
             [:multiply, 51, 387, 215],
             [:add, 64, 23, 314]
           ] == result
  end

  test "part1 example", %{input: input} do
    result = input |> p1_parse() |> part1()

    assert 4_277_556 == result
  end

  test "part1" do
    input = File.read!("./puzzle_input/day_06.txt")

    result = input |> p1_parse() |> part1()

    IO.puts("Part 1: #{result}")
  end

  test "part2 parse", %{input: input} do
    result = p2_parse(input)

    assert [
             [:multiply, 1, 24, 356],
             [:add, 369, 248, 8],
             [:multiply, 32, 581, 175],
             [:add, 623, 431, 4]
           ] == result
  end

  test "part2 example", %{input: input} do
    result = input |> p2_parse() |> part2()

    assert 3_263_827 == result
  end

  test "part2" do
    input = File.read!("./puzzle_input/day_06.txt")

    result = input |> p2_parse() |> part2()

    IO.puts("Part 2: #{result}")
  end
end
