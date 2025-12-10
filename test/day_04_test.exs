defmodule Day04Test do
  use ExUnit.Case, async: true

  import Day04

  setup do
    [
      input: """
      ..@@.@@@@.
      @@@.@.@.@@
      @@@@@.@.@@
      @.@@@@..@.
      @@.@@@@.@@
      .@@@@@@@.@
      .@.@.@.@@@
      @.@@@.@@@@
      .@@@@@@@@.
      @.@.@@@.@.
      """
    ]
  end

  test "parse", %{input: input} do
    map = parse(input)

    assert [
             [:none, :none, :roll, :roll, :none, :roll, :roll, :roll, :roll, :none],
             [:roll, :roll, :roll, :none, :roll, :none, :roll, :none, :roll, :roll],
             [:roll, :roll, :roll, :roll, :roll, :none, :roll, :none, :roll, :roll],
             [:roll, :none, :roll, :roll, :roll, :roll, :none, :none, :roll, :none],
             [:roll, :roll, :none, :roll, :roll, :roll, :roll, :none, :roll, :roll],
             [:none, :roll, :roll, :roll, :roll, :roll, :roll, :roll, :none, :roll],
             [:none, :roll, :none, :roll, :none, :roll, :none, :roll, :roll, :roll],
             [:roll, :none, :roll, :roll, :roll, :none, :roll, :roll, :roll, :roll],
             [:none, :roll, :roll, :roll, :roll, :roll, :roll, :roll, :roll, :none],
             [:roll, :none, :roll, :none, :roll, :roll, :roll, :none, :roll, :none]
           ] == map
  end

  test "part1 example", %{input: input} do
    result = input |> parse() |> part1()

    assert result == 13
  end

  test "part1" do
    input = File.read!("./puzzle_input/day_04.txt")

    result = input |> parse() |> part1()

    IO.puts("Part 1: #{result}")
  end
end
