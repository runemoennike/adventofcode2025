defmodule Day10 do
  require Logger
  import Bitwise
  use Helpers.TupleOps

  Logger.configure_backend(:console, format: "[$level] $message\n")

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

  #
  # Part 1
  #

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

  #
  # Part 2 - attempt with bounded DFS
  #

  def part2(problems) do
    problems
    |> Task.async_stream(
      fn %{reqs: goal, action_vectors: actions} ->
        Logger.info("Starting #{inspect(goal)}")

        solve_vector(goal, actions)
        |> tap(fn n -> Logger.info("Solved #{inspect(goal)}: #{n}") end)
      end,
      max_concurrency: System.schedulers_online(),
      timeout: :infinity
    )
    |> Enum.reduce(0, fn
      {:ok, value}, acc -> acc + value
      {:exit, _}, acc -> acc
    end)
  end

  def solve_vector(goal, actions) do
    # We want to visit as few states as possibl, so try the joltages with fewest butons affecting
    # them first. Fewer buttons affecting a joltage results in fewer states to branch frem as each
    # recursion level.
    affections =
      affection_map(actions)
      |> Enum.sort_by(fn {jidx, _buttons, num_buttons} -> {num_buttons, elem(goal, jidx)} end)

    state = Tuple.duplicate(0, tuple_size(goal))

    solve_vector(state, goal, affections, 0, nil)
  end

  def solve_vector(_state, _goal, [], _depth, bound), do: bound

  # Heavily inspired by https://github.com/michel-kraemer/adventofcode-rust/blob/main/2025/day10/src/main.rs
  def solve_vector(state, goal, [{jidx, buttons, num_buttons} | rem_affections], depth, bound) do
    # Since each button can affect a slot with a value of no more than one, 
    # we know we must press these buttons exactly as many times as the joltages required
    # for the given slot. We just don't know which combination of affeting buttons to use.
    jolt_max = elem(goal, jidx)
    jolt_state = elem(state, jidx)
    presses = jolt_max - jolt_state
    new_depth = depth + presses

    if depth + presses >= bound do
      bound
    else
      # Try all possible ways to combine the required presses using the available buttons.
      distribute(num_buttons, presses)
      |> Enum.reduce_while(bound, fn distribution, new_bound ->
        new_state = state |> apply_distribution(distribution, buttons)

        cond do
          new_state == goal ->
            # Don't we already know depth + presses < bound? Any bound found from recursion must be larger.
            {:halt, min(new_bound, new_depth)}

          greater_than?(new_state, goal) ->
            {:cont, new_bound}

          true ->
            {:cont, solve_vector(new_state, goal, rem_affections, new_depth, new_bound)}
        end
      end)
    end
  end

  def affection_map(actions) do
    for idx <- 0..(tuple_size(hd(actions)) - 1) do
      filtered_actions = actions |> Enum.filter(&(elem(&1, idx) == 1))
      {idx, filtered_actions, length(filtered_actions)}
    end
  end

  def apply_distribution(acc, [], []), do: acc

  def apply_distribution(acc, [factor | fs], [btn | bs]),
    do: apply_distribution(mac(acc, btn, factor), fs, bs)

  def distribute(num_buckets, sum) do
    Stream.resource(
      fn -> [{num_buckets, sum, []}] end,
      fn
        [] ->
          {:halt, []}

        [{1, sum, acc} | rest] ->
          {[[sum | acc]], rest}

        [{n, sum, acc} | rest] ->
          next =
            for x <- 0..sum,
                do: {n - 1, sum - x, [x | acc]}

          {[], next ++ rest}
      end,
      fn _ -> :ok end
    )
  end

  #
  # Part 2 using z3 solver, from https://elixirforum.com/t/advent-of-code-2025-day-10/73612/5
  #

  def part2_z3(problems) do
    problems
    |> Task.async_stream(
      fn %{reqs: goal, action_vectors: actions} ->
        Logger.info("Starting #{inspect(goal)}")

        solve_z3(goal, actions)
        |> tap(fn n -> Logger.info("Solved #{inspect(goal)}: #{n}") end)
      end,
      max_concurrency: System.schedulers_online(),
      ordered: false,
      timeout: 60000
    )
    |> Enum.sum_by(&elem(&1, 1))
  end

  defp solve_z3(goal, actions) do
    vars = for i <- 0..length(actions), do: String.to_atom("x#{i}")
    action_to_vars = actions |> Enum.zip(vars) |> Map.new()

    declarations =
      Enum.map(vars, fn arg -> "(declare-const #{arg} Int) (assert (>= #{arg} 0))" end)

    assertions =
      affection_map(actions)
      |> Enum.map(fn {jidx, as, _len} ->
        "(assert (= #{elem(goal, jidx)} (+ #{as |> Enum.map(&action_to_vars[&1]) |> Enum.join(" ")})))"
      end)
      |> Enum.join(" ")

    command =
      """
      #{declarations}
      #{assertions}
      (define-fun sum () Int (+ #{Enum.join(vars, " ")}))
      (minimize sum)
      (check-sat)
      (get-value (sum))
      """

    z3 = System.find_executable("z3")
    port = Port.open({:spawn_executable, z3}, [:binary, args: ["-in"]])
    send(port, {self(), {:command, command}})

    result = receive_result(port)
    true = Port.close(port)
    result
  end

  defp receive_result(port, acc \\ "") do
    receive do
      {^port, {:data, data}} ->
        buf = acc <> data

        case Regex.run(~r/\(\(sum\s+(-?\d+)\)\)/, buf) do
          [_, num] -> String.to_integer(num)
          _ -> receive_result(port, buf)
        end
    end
  end
end
