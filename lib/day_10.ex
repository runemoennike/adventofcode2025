defmodule Day10 do
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
    |> Enum.map(fn %{goal: goal, actions: actions} -> solve(goal, actions) end)
    |> Enum.map(length / 1)
    |> Enum.sum()
  end

  def solve(goal, actions), do: solve(goal, actions, 0, [])
  def solve(goal, actions, state, [h | _t] = path) when bxor(state, step) == goal, do: path

  def solve(goal, actions, path) do
  end
end
