defmodule Day10Test do
  use ExUnit.Case, async: false

  import Day10

  setup do
    [
      input: """
      [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
      [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
      [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
      """
    ]
  end

  test "parse", %{input: input} do
    result = parse(input)

    assert [
             %{
               goal: 0b0110,
               action_bitmaps: [0b1000, 0b1010, 0b0100, 0b1100, 0b0101, 0b0011],
               action_vectors: [
                 {0, 0, 0, 1},
                 {0, 1, 0, 1},
                 {0, 0, 1, 0},
                 {0, 0, 1, 1},
                 {1, 0, 1, 0},
                 {1, 1, 0, 0}
               ],
               reqs: {3, 5, 4, 7}
             },
             %{
               goal: 0b01000,
               action_bitmaps: [0b11101, 0b01100, 0b10001, 0b00111, 0b11110],
               action_vectors: [
                 {1, 0, 1, 1, 1},
                 {0, 0, 1, 1, 0},
                 {1, 0, 0, 0, 1},
                 {1, 1, 1, 0, 0},
                 {0, 1, 1, 1, 1}
               ],
               reqs: {7, 5, 12, 7, 2}
             },
             %{
               goal: 0b101110,
               action_bitmaps: [0b011111, 0b011001, 0b110111, 0b000110],
               action_vectors: [
                 {1, 1, 1, 1, 1, 0},
                 {1, 0, 0, 1, 1, 0},
                 {1, 1, 1, 0, 1, 1},
                 {0, 1, 1, 0, 0, 0}
               ],
               reqs: {10, 11, 11, 5, 10, 5}
             }
           ] == result
  end

  test "part1 example", %{input: input} do
    result = input |> parse() |> part1()

    assert 7 == result
  end

  test "part1" do
    input = File.read!("./puzzle_input/day_10.txt")

    result = input |> parse() |> part1()

    IO.puts("Part 1: #{result}")
  end

  test "tuple elementwise addition" do
    for l <- 1..10 do
      t = 1..l |> Enum.to_list() |> List.to_tuple()
      s = 2..(l * 2)//2 |> Enum.to_list() |> List.to_tuple()
      assert s == add(t, t)
    end
  end

  test "tuple elementwise subtraction" do
    for l <- 1..10 do
      t = 1..l |> Enum.to_list() |> List.to_tuple()
      s = Tuple.duplicate(0, l)
      assert s == sub(t, t)
    end
  end

  test "tuple elementwise greater than" do
    for l <- 1..10 do
      a = 1..l |> Enum.to_list() |> List.to_tuple()
      b = 2..(l + 1) |> Enum.to_list() |> List.to_tuple()
      assert greater_than?(b, a)
      assert not greater_than?(a, b)
      assert not greater_than?(a, a)
    end
  end

  test "affection map", %{input: input} do
    result =
      input
      |> parse()
      |> Enum.map(fn %{action_vectors: actions} -> affection_map(actions) end)

    assert [
             [
               {0, [{1, 0, 1, 0}, {1, 1, 0, 0}], 2},
               {1, [{0, 1, 0, 1}, {1, 1, 0, 0}], 2},
               {2, [{0, 0, 1, 0}, {0, 0, 1, 1}, {1, 0, 1, 0}], 3},
               {3, [{0, 0, 0, 1}, {0, 1, 0, 1}, {0, 0, 1, 1}], 3}
             ],
             [
               {0, [{1, 0, 1, 1, 1}, {1, 0, 0, 0, 1}, {1, 1, 1, 0, 0}], 3},
               {1, [{1, 1, 1, 0, 0}, {0, 1, 1, 1, 1}], 2},
               {2, [{1, 0, 1, 1, 1}, {0, 0, 1, 1, 0}, {1, 1, 1, 0, 0}, {0, 1, 1, 1, 1}], 4},
               {3, [{1, 0, 1, 1, 1}, {0, 0, 1, 1, 0}, {0, 1, 1, 1, 1}], 3},
               {4, [{1, 0, 1, 1, 1}, {1, 0, 0, 0, 1}, {0, 1, 1, 1, 1}], 3}
             ],
             [
               {0, [{1, 1, 1, 1, 1, 0}, {1, 0, 0, 1, 1, 0}, {1, 1, 1, 0, 1, 1}], 3},
               {1, [{1, 1, 1, 1, 1, 0}, {1, 1, 1, 0, 1, 1}, {0, 1, 1, 0, 0, 0}], 3},
               {2, [{1, 1, 1, 1, 1, 0}, {1, 1, 1, 0, 1, 1}, {0, 1, 1, 0, 0, 0}], 3},
               {3, [{1, 1, 1, 1, 1, 0}, {1, 0, 0, 1, 1, 0}], 2},
               {4, [{1, 1, 1, 1, 1, 0}, {1, 0, 0, 1, 1, 0}, {1, 1, 1, 0, 1, 1}], 3},
               {5, [{1, 1, 1, 0, 1, 1}], 1}
             ]
           ] == result
  end

  test "distribute" do
    assert [[1]] == distribute(1, 1) |> Enum.to_list()
    assert [[1, 0], [0, 1]] == distribute(2, 1) |> Enum.to_list()
    assert [[1, 0, 0], [0, 1, 0], [0, 0, 1]] == distribute(3, 1) |> Enum.to_list()
    assert [[2, 0], [1, 1], [0, 2]] == distribute(2, 2) |> Enum.to_list()
  end

  test "apply distribution" do
    assert {1} == apply_distribution({0}, [1], [{1}])
    assert {2, 2} == apply_distribution({0, 0}, [2, 2], [{1, 0}, {0, 1}])

    assert {1, 2, 3} ==
             apply_distribution({0, 0, 0}, [1, 0, 2], [{1, 0, 1}, {0, 1, 0}, {0, 1, 1}])
  end

  test "part2 example", %{input: input} do
    result = input |> parse() |> part2()

    assert 33 == result
  end

  # test "part2" do
  #   input = File.read!("./puzzle_input/day_10.txt")
  #
  #   result = input |> parse() |> Enum.drop(9) |> part2()
  #
  #   IO.puts("Part 2: #{result}")
  # end
end
