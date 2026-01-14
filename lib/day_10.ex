defmodule Day10 do
  import Bitwise

  def parse(input) do
    input
    |> String.split(["\n", "\r\n"], trim: true)
    |> Enum.map(fn l ->
      String.split(l, " ")
      |> Enum.map(fn s -> String.slice(s, 1, String.length(s) - 2) end)
      |> then(fn segments ->
        {last, [first | middle]} = List.pop_at(segments, -1)

        %{
          goal: parse_goal(first),
          action_bitmaps: Enum.map(middle, &parse_action_bitmap/1),
          action_vectors: Enum.map(middle, &parse_action_vector(&1, String.length(first))),
          reqs: parse_reqs(last)
        }
      end)
    end)
  end

  def parse_goal(input) do
    input
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.sum_by(fn
      {".", _} -> 0
      {"#", pos} -> 2 ** pos
    end)
  end

  def parse_action_bitmap(input), do: integer_tokens(input) |> Enum.sum_by(fn n -> 2 ** n end)

  def parse_action_vector(input, len) do
    integer_tokens(input)
    |> Enum.reduce(Tuple.duplicate(0, len), fn pos, vec -> vec |> put_elem(pos, 1) end)
  end

  def parse_reqs(input), do: integer_tokens(input) |> List.to_tuple()

  def integer_tokens(input), do: input |> String.split(",") |> Enum.map(&String.to_integer/1)

  def part1(problems) do
    problems
    |> Enum.sum_by(fn %{goal: goal, action_bitmaps: actions} ->
      solve_bitmap(goal, actions) |> hd() |> length()
    end)
  end

  def solve_bitmap(goal, actions) do
    for(depth <- 1..length(actions), do: depth)
    |> Enum.reduce_while(nil, fn depth, _acc ->
      case solve_bitmap(0, goal, actions, [], depth) do
        [] -> {:cont, nil}
        solution -> {:halt, solution}
      end
    end)
  end

  def solve_bitmap(_state, _goal, [], _history, _depth), do: []
  def solve_bitmap(_state, _goal, _actions, _history, 0), do: []

  def solve_bitmap(state, goal, actions, history, depth) do
    actions
    |> Enum.flat_map(fn action ->
      new_history = [action | history]
      new_state = bxor(state, action)
      new_depth = depth - 1

      if new_state == goal do
        [new_history]
      else
        new_actions = actions |> List.delete(action)
        solve_bitmap(new_state, goal, new_actions, new_history, new_depth)
      end
    end)
  end

  def part2(problems) do
    problems
    |> Enum.sum_by(fn %{reqs: goal, action_vectors: actions} ->
      solve_vector(goal, actions)
    end)
  end

  def solve_vector(goal, actions) do
    IO.inspect(goal, label: "SOLVING -----------------")

    for(depth <- 1..20, do: depth)
    |> Enum.reduce_while(nil, fn depth, _acc ->
      IO.inspect(depth)

      case solve_vector(Tuple.duplicate(0, tuple_size(goal)), goal, actions, 0, depth) do
        nil -> {:cont, nil}
        solution -> {:halt, solution}
      end
    end)
  end

  def solve_vector({s1}, {g1}, _actions, _history, _depth) when s1 > g1, do: nil

  def solve_vector({s1, s2}, {g1, g2}, _actions, _history, _depth) when s1 > g1 when s2 > g2,
    do: nil

  def solve_vector({s1, s2, s3}, {g1, g2, g3}, _actions, _history, _depth)
      when s1 > g1
      when s2 > g2
      when s3 > g3,
      do: nil

  def solve_vector({s1, s2, s3, s4}, {g1, g2, g3, g4}, _actions, _history, _depth)
      when s1 > g1
      when s2 > g2
      when s3 > g3
      when s4 > g4,
      do: nil

  def solve_vector({s1, s2, s3, s4, s5}, {g1, g2, g3, g4, g5}, _actions, _history, _depth)
      when s1 > g1
      when s2 > g2
      when s3 > g3
      when s4 > g4
      when s5 > g5,
      do: nil

  def solve_vector({s1, s2, s3, s4, s5, s6}, {g1, g2, g3, g4, g5, g6}, _actions, _history, _depth)
      when s1 > g1
      when s2 > g2
      when s3 > g3
      when s4 > g4
      when s5 > g5
      when s6 > g6,
      do: nil

  def solve_vector(
        {s1, s2, s3, s4, s5, s6, s7},
        {g1, g2, g3, g4, g5, g6, g7},
        _actions,
        _history,
        _depth
      )
      when s1 > g1
      when s2 > g2
      when s3 > g3
      when s4 > g4
      when s5 > g5
      when s6 > g6
      when s7 > g7,
      do: nil

  def solve_vector(
        {s1, s2, s3, s4, s5, s6, s7, s8},
        {g1, g2, g3, g4, g5, g6, g7, g8},
        _actions,
        _history,
        _depth
      )
      when s1 > g1
      when s2 > g2
      when s3 > g3
      when s4 > g4
      when s5 > g5
      when s6 > g6
      when s7 > g7
      when s8 > g8,
      do: nil

  def solve_vector(
        {s1, s2, s3, s4, s5, s6, s7, s8, s9},
        {g1, g2, g3, g4, g5, g6, g7, g8, g9},
        _actions,
        _history,
        _depth
      )
      when s1 > g1
      when s2 > g2
      when s3 > g3
      when s4 > g4
      when s5 > g5
      when s6 > g6
      when s7 > g7
      when s8 > g8
      when s9 > g9,
      do: nil

  def solve_vector(
        {s1, s2, s3, s4, s5, s6, s7, s8, s9, s10},
        {g1, g2, g3, g4, g5, g6, g7, g8, g9, g10},
        _actions,
        _history,
        _depth
      )
      when s1 > g1
      when s2 > g2
      when s3 > g3
      when s4 > g4
      when s5 > g5
      when s6 > g6
      when s7 > g7
      when s8 > g8
      when s9 > g9
      when s10 > g10,
      do: nil

  def solve_vector(_state, _goal, _actions, _history, 0), do: nil

  def solve_vector(state, goal, actions, history, depth) do
    actions
    |> Enum.reduce_while(nil, fn action, _acc ->
      new_history = history + 1
      new_state = add(state, action)
      new_depth = depth - 1

      if new_state == goal do
        {:halt, new_history}
      else
        case solve_vector(new_state, goal, actions, new_history, new_depth) do
          nil -> {:cont, nil}
          v -> {:halt, v}
        end
      end
    end)
  end

  def add({a1}, {b1}), do: {a1 + b1}
  def add({a1, a2}, {b1, b2}), do: {a1 + b1, a2 + b2}
  def add({a1, a2, a3}, {b1, b2, b3}), do: {a1 + b1, a2 + b2, a3 + b3}
  def add({a1, a2, a3, a4}, {b1, b2, b3, b4}), do: {a1 + b1, a2 + b2, a3 + b3, a4 + b4}

  def add({a1, a2, a3, a4, a5}, {b1, b2, b3, b4, b5}),
    do: {a1 + b1, a2 + b2, a3 + b3, a4 + b4, a5 + b5}

  def add({a1, a2, a3, a4, a5, a6}, {b1, b2, b3, b4, b5, b6}),
    do: {a1 + b1, a2 + b2, a3 + b3, a4 + b4, a5 + b5, a6 + b6}

  def add({a1, a2, a3, a4, a5, a6, a7}, {b1, b2, b3, b4, b5, b6, b7}),
    do: {a1 + b1, a2 + b2, a3 + b3, a4 + b4, a5 + b5, a6 + b6, a7 + b7}

  def add({a1, a2, a3, a4, a5, a6, a7, a8}, {b1, b2, b3, b4, b5, b6, b7, b8}),
    do: {a1 + b1, a2 + b2, a3 + b3, a4 + b4, a5 + b5, a6 + b6, a7 + b7, a8 + b8}

  def add({a1, a2, a3, a4, a5, a6, a7, a8, a9}, {b1, b2, b3, b4, b5, b6, b7, b8, b9}),
    do: {a1 + b1, a2 + b2, a3 + b3, a4 + b4, a5 + b5, a6 + b6, a7 + b7, a8 + b8, a9 + b9}

  def add({a1, a2, a3, a4, a5, a6, a7, a8, a9, a10}, {b1, b2, b3, b4, b5, b6, b7, b8, b9, b10}),
    do:
      {a1 + b1, a2 + b2, a3 + b3, a4 + b4, a5 + b5, a6 + b6, a7 + b7, a8 + b8, a9 + b9, a10 + b10}
end
