defmodule Day05Test do
  use ExUnit.Case, async: true

  import Day05

  setup do
    [
      input: """
      3-5
      10-14
      16-20
      12-18

      1
      5
      8
      11
      17
      32
      """
    ]
  end

  test "parse", %{input: input} do
    {fresh, available} = parse(input)

    assert [3..5, 10..14, 16..20, 12..18] == fresh
    assert [1, 5, 8, 11, 17, 32] == available
  end

  test "part1 example", %{input: input} do
    result = input |> parse() |> then(fn {fresh, available} -> part1(fresh, available) end)

    assert result == 3
  end

  test "part1" do
    input = File.read!("./puzzle_input/day_05.txt")

    result = input |> parse() |> then(fn {fresh, available} -> part1(fresh, available) end)

    IO.puts("Part 1: #{result}")
  end

  test "part2 example", %{input: input} do
    result = input |> parse() |> then(fn {fresh, _} -> part2(fresh) end)

    assert result == 14
  end

  test "part2" do
    input = File.read!("./puzzle_input/day_05.txt")

    result = input |> parse() |> then(fn {fresh, _} -> part2(fresh) end)

    IO.puts("Part 2: #{result}")
  end
end
