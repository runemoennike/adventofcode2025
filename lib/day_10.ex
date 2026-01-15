defmodule Day10 do
  import Bitwise
  use Helpers.TupleOps

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

    affections = affection_map(actions) |> Map.to_list() |> Enum.sort(fn {_k, v} -> length(v) end)
    state = Tuple.duplicate(0, tuple_size(goal))

    solve_vector(state, goal, affections)
    |> IO.inspect()
  end

  # Heavily inspired by https://github.com/michel-kraemer/adventofcode-rust/blob/main/2025/day10/src/main.rs
  # min?
  def solve_vector(state, goal, [{bidx, buttons} | rem_affections]) do
    jolt_max = elem(goal, bidx)
    jolt_state = elem(state, bidx)
    comps = distribute(length(buttons), jolt_max - jolt_state)

    # actions
    # |> Enum.reduce(min, fn action, new_min ->
    #   new_state = add(state, action)
    #
    #   cond do
    #     new_state == goal ->
    #       min(new_count, min)
    #
    #     greater_than?(new_state, goal) ->
    #       new_min
    #
    #     true ->
    #       min(count + solve_vector(new_state, goal, actions, new_count, new_min), new_min)
    #   end
    # end)
  end

  def affection_map(actions) do
    for idx <- 0..(tuple_size(hd(actions)) - 1), into: %{} do
      {idx, actions |> Enum.filter(&(elem(&1, idx) == 1))}
    end
  end

  defp distribute(0, 0), do: [[]]
  defp distribute(0, _), do: []

  defp distribute(num_buckets, sum),
    do: for(x <- 0..sum, rest <- distribute(num_buckets - 1, sum - x), do: [x | rest])
end
