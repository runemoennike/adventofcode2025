defmodule Day07Test do
  use ExUnit.Case, async: true

  import Day07

  setup do
    [
      input: """
      .......S.......
      ...............
      .......^.......
      ...............
      ......^.^......
      ...............
      .....^.^.^.....
      ...............
      ....^.^...^....
      ...............
      ...^.^...^.^...
      ...............
      ..^...^.....^..
      ...............
      .^.^.^.^.^...^.
      ...............
      """
    ]
  end

  test "parse", %{input: input} do
    result = parse(input)

    assert {
             {7, 0},
             %{
               {1, 14} => :split,
               {2, 12} => :split,
               {3, 10} => :split,
               {3, 14} => :split,
               {4, 8} => :split,
               {5, 6} => :split,
               {5, 10} => :split,
               {5, 14} => :split,
               {6, 4} => :split,
               {6, 8} => :split,
               {6, 12} => :split,
               {7, 2} => :split,
               {7, 6} => :split,
               {7, 14} => :split,
               {8, 4} => :split,
               {9, 6} => :split,
               {9, 10} => :split,
               {9, 14} => :split,
               {10, 8} => :split,
               {11, 10} => :split,
               {12, 12} => :split,
               {13, 14} => :split
             },
             {15, 16}
           } == result
  end

  test "part1 example", %{input: input} do
    result = input |> parse() |> part1()

    assert 21 == result
  end

  # test "part1" do
  #   input = File.read!("./puzzle_input/day_06.txt")
  #
  #   result = input |> p1_parse() |> part1()
  #
  #   IO.puts("Part 1: #{result}")
  # end
  #
  # test "part2 parse", %{input: input} do
  #   result = p2_parse(input)
  #
  #   assert [
  #            [:multiply, 1, 24, 356],
  #            [:add, 369, 248, 8],
  #            [:multiply, 32, 581, 175],
  #            [:add, 623, 431, 4]
  #          ] == result
  # end
  #
  # test "part2 example", %{input: input} do
  #   result = input |> p2_parse() |> part2()
  #
  #   assert 3_263_827 == result
  # end
  #
  # test "part2" do
  #   input = File.read!("./puzzle_input/day_06.txt")
  #
  #   result = input |> p2_parse() |> part2()
  #
  #   IO.puts("Part 2: #{result}")
  # end
end
