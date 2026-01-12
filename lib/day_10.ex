defmodule Day10 do
  import Bitwise

  def parse(input) do
    input
    |> String.split(["\n", "\r\n"], trim: true)
    |> Enum.map(fn l ->
      String.split(l, " ")
      |> Enum.map(fn s -> String.slice(s, 1, String.length(s) - 2) end)
      |> then(fn segments ->
        %{
          goal: parse_goal(hd(segments)),
          actions: Enum.slice(segments, 1, length(segments) - 2) |> Enum.map(&parse_action/1),
          reqs: parse_reqs(List.last(segments))
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

  def parse_action(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum_by(fn n -> 2 ** n end)
  end

  def parse_reqs(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def part1(problems) do
    problems
    |> Enum.map(fn %{goal: goal, actions: actions} -> solve(goal, actions) |> hd() |> length() end)
    |> Enum.sum()
  end

  def solve(goal, actions) do
    for(depth <- 1..length(actions), do: depth)
    |> Enum.reduce_while(nil, fn depth, _acc ->
      case solve(0, goal, actions, [], depth) do
        [] -> {:cont, nil}
        solution -> {:halt, solution}
      end
    end)
  end

  def solve(_state, _goal, [], _history, _depth), do: []
  def solve(_state, _goal, _actions, _history, 0), do: []

  def solve(state, goal, actions, history, depth) do
    actions
    |> Enum.flat_map(fn action ->
      new_history = [action | history]
      new_state = bxor(state, action)
      new_depth = depth - 1

      if new_state == goal do
        [new_history]
      else
        new_actions = actions |> List.delete(action)
        solve(new_state, goal, new_actions, new_history, new_depth)
      end
    end)
  end

  def bits(n), do: for(<<(b::1 <- <<n>>)>>, do: b) |> Enum.join()
end
