defmodule Day03Test do
  use ExUnit.Case, async: true

  import Day03

  setup do
    [
      input: """
      987654321111111
      811111111111119
      234234234234278
      818181911112111
      """
    ]
  end

  test "parse", %{input: input} do
    banks = parse(input)

    assert [
             [9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1],
             [8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9],
             [2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8],
             [8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1]
           ] == banks
  end

  test "part1 example", %{input: input} do
    result = input |> parse() |> part1()

    assert result == 357
  end

  test "part1" do
    input = File.read!("./puzzle_input/day_03.txt")

    result = input |> parse() |> part1()

    IO.puts("Part 1: #{result}")
  end

  test "part2 example", %{input: input} do
    result = input |> parse() |> part2()

    assert result == 3_121_910_778_619
  end

  test "part2" do
    input = File.read!("./puzzle_input/day_03.txt")

    result = input |> parse() |> part2()

    IO.puts("Part 2: #{result}")
  end
end
