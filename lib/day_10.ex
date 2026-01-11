defmodule Day10 do
  import Bitwise

  def parse(input) do
    input
    |> String.split(["\n", "\r\n"], trim: true)
    |> Enum.map(fn l ->
      l
      |> String.split(" ")
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
    |> String.slice(1, String.length(input) - 2)
    |> String.graphemes()
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.sum_by(fn
      {".", _} -> 0
      {"#", pos} -> 2 ** pos
    end)
  end

  def parse_action(input) do
    input
    |> String.slice(1, String.length(input) - 2)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum_by(fn n -> 2 ** n end)
  end

  def parse_reqs(input) do
    input
    |> String.slice(1, String.length(input) - 2)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def part1(problems) do
    problems
    |> Enum.map(fn %{goal: goal, actions: actions} ->
      IO.inspect(actions, label: "Actions")
      solve(goal, actions)
    end)
    |> Enum.map(fn sols -> Enum.sort_by(sols, &length/1) end)
    |> IO.inspect(limit: :infinity)
    |> Enum.map(&length/1)
    |> Enum.sum()
  end

  def solve(goal, actions), do: solve(0, goal, actions, [])
  def solve(_state, _goal, [], _history), do: []

  def solve(state, goal, actions, history) do
    actions
    |> Enum.flat_map(fn action ->
      new_history = [action | history]
      new_state = bxor(state, action)

      # IO.puts("#{state} + #{action} -> #{new_state}")
      # IO.inspect(history)

      if new_state == goal do
        [new_history]
      else
        new_actions = actions |> List.delete(action)
        solve(new_state, goal, new_actions, new_history)
      end
    end)
  end
end
