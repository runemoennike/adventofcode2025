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

    assert %{
             {0, 0} => :none,
             {0, 1} => :roll,
             {0, 2} => :roll,
             {0, 3} => :roll,
             {0, 4} => :roll,
             {0, 5} => :none,
             {0, 6} => :none,
             {0, 7} => :roll,
             {0, 8} => :none,
             {0, 9} => :roll,
             {1, 0} => :none,
             {1, 1} => :roll,
             {1, 2} => :roll,
             {1, 3} => :none,
             {1, 4} => :roll,
             {1, 5} => :roll,
             {1, 6} => :roll,
             {1, 7} => :none,
             {1, 8} => :roll,
             {1, 9} => :none,
             {2, 0} => :roll,
             {2, 1} => :roll,
             {2, 2} => :roll,
             {2, 3} => :roll,
             {2, 4} => :none,
             {2, 5} => :roll,
             {2, 6} => :none,
             {2, 7} => :roll,
             {2, 8} => :roll,
             {2, 9} => :roll,
             {3, 0} => :roll,
             {3, 1} => :none,
             {3, 2} => :roll,
             {3, 3} => :roll,
             {3, 4} => :roll,
             {3, 5} => :roll,
             {3, 6} => :roll,
             {3, 7} => :roll,
             {3, 8} => :roll,
             {3, 9} => :none,
             {4, 0} => :none,
             {4, 1} => :roll,
             {4, 2} => :roll,
             {4, 3} => :roll,
             {4, 4} => :roll,
             {4, 5} => :roll,
             {4, 6} => :none,
             {4, 7} => :roll,
             {4, 8} => :roll,
             {4, 9} => :roll,
             {5, 0} => :roll,
             {5, 1} => :none,
             {5, 2} => :none,
             {5, 3} => :roll,
             {5, 4} => :roll,
             {5, 5} => :roll,
             {5, 6} => :roll,
             {5, 7} => :none,
             {5, 8} => :roll,
             {5, 9} => :roll,
             {6, 0} => :roll,
             {6, 1} => :roll,
             {6, 2} => :roll,
             {6, 3} => :none,
             {6, 4} => :roll,
             {6, 5} => :roll,
             {6, 6} => :none,
             {6, 7} => :roll,
             {6, 8} => :roll,
             {6, 9} => :roll,
             {7, 0} => :roll,
             {7, 1} => :none,
             {7, 2} => :none,
             {7, 3} => :none,
             {7, 4} => :none,
             {7, 5} => :roll,
             {7, 6} => :roll,
             {7, 7} => :roll,
             {7, 8} => :roll,
             {7, 9} => :none,
             {8, 0} => :roll,
             {8, 1} => :roll,
             {8, 2} => :roll,
             {8, 3} => :roll,
             {8, 4} => :roll,
             {8, 5} => :none,
             {8, 6} => :roll,
             {8, 7} => :roll,
             {8, 8} => :roll,
             {8, 9} => :roll,
             {9, 0} => :none,
             {9, 1} => :roll,
             {9, 2} => :roll,
             {9, 3} => :none,
             {9, 4} => :roll,
             {9, 5} => :roll,
             {9, 6} => :roll,
             {9, 7} => :roll,
             {9, 8} => :none,
             {9, 9} => :none
           } == map
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

  test "part2 example", %{input: input} do
    result = input |> parse() |> part2()

    assert result == 43
  end

  test "part2" do
    input = File.read!("./puzzle_input/day_04.txt")

    result = input |> parse() |> part2()

    IO.puts("Part 2: #{result}")
  end
end
