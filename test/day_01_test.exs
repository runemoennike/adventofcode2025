defmodule Day01Test do
  use ExUnit.Case, async: true

  import Day01

  setup do
    [
      input: """
      L68
      L30
      R48
      L5
      R60
      L55
      L1
      L99
      R14
      L82
      """
    ]
  end

  test "parse", %{input: input} do
    steps = parse(input)

    assert [-68, -30, 48, -5, 60, -55, -1, -99, 14, -82] == steps
  end

  test "part1 example", %{input: input} do
    result = input |> parse() |> part1()

    assert result == 3
  end

  test "part1" do
    input = File.read!("./puzzle_input/day_01.txt")

    result = input |> parse() |> part1()

    IO.puts("Part 1: #{result}")
  end

  test "part2 example", %{input: input} do
    result = input |> parse() |> part2()

    assert result == 6
  end

  test "part2" do
    input = File.read!("./puzzle_input/day_01.txt")

    result = input |> parse() |> part2()

    IO.puts("Part 2: #{result}")
  end
end
