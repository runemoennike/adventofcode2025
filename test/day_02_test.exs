defmodule Day02Test do
  use ExUnit.Case, async: true

  import Day02

  setup do
    [
      input:
        "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
    ]
  end

  test "parse", %{input: input} do
    steps = parse(input)

    assert [
             {11, 22},
             {95, 115},
             {998, 1012},
             {1_188_511_880, 1_188_511_890},
             {222_220, 222_224},
             {1_698_522, 1_698_528},
             {446_443, 446_449},
             {38_593_856, 38_593_862},
             {565_653, 565_659},
             {824_824_821, 824_824_827},
             {2_121_212_118, 2_121_212_124}
           ] == steps
  end

  test "part1 example", %{input: input} do
    result = input |> parse() |> part1()

    assert result == 1_227_775_554
  end

  test "part1" do
    input = File.read!("./puzzle_input/day_02.txt")

    result = input |> parse() |> part1()

    IO.puts("Part 1: #{result}")
  end

  test "part2 example", %{input: input} do
    result = input |> parse() |> part2()

    assert result == 4_174_379_265
  end

  test "part2" do
    input = File.read!("./puzzle_input/day_02.txt")

    result = input |> parse() |> part2()

    IO.puts("Part 2: #{result}")
  end
end
