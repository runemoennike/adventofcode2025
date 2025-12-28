defmodule Day08Test do
  use ExUnit.Case, async: true

  import Day08

  setup do
    [
      input: """
      162,817,812
      57,618,57
      906,360,560
      592,479,940
      352,342,300
      466,668,158
      542,29,236
      431,825,988
      739,650,466
      52,470,668
      216,146,977
      819,987,18
      117,168,530
      805,96,715
      346,949,466
      970,615,88
      941,993,340
      862,61,35
      984,92,344
      425,690,689
      """
    ]
  end

  test "parse", %{input: input} do
    result = parse(input)

    assert [
             {162, 817, 812},
             {57, 618, 57},
             {906, 360, 560},
             {592, 479, 940},
             {352, 342, 300},
             {466, 668, 158},
             {542, 29, 236},
             {431, 825, 988},
             {739, 650, 466},
             {52, 470, 668},
             {216, 146, 977},
             {819, 987, 18},
             {117, 168, 530},
             {805, 96, 715},
             {346, 949, 466},
             {970, 615, 88},
             {941, 993, 340},
             {862, 61, 35},
             {984, 92, 344},
             {425, 690, 689}
           ] == result
  end

  test "distance" do
    assert_in_delta 1.732, distance({2, 5, 6}, {3, 4, 7}), 0.0001
  end

  test "part1 example", %{input: input} do
    result = input |> parse() |> part1()

    assert 40 == result
  end

  # test "part1" do
  #   input = File.read!("./puzzle_input/day_08.txt")
  #
  #   result = input |> parse() |> part1()
  #
  #   IO.puts("Part 1: #{result}")
  # end
  #
  # test "part2 example", %{input: input} do
  #   result = input |> parse() |> part2()
  #
  #   assert 40 == result
  # end
  #
  # test "part2" do
  #   input = File.read!("./puzzle_input/day_08.txt")
  #
  #   result = input |> parse() |> part2()
  #
  #   IO.puts("Part 2: #{result}")
  # end
end
