defmodule Day08 do
  def parse(input) do
    input
    |> String.split(["\n", "\r\n"], trim: true)
    |> Enum.map(fn l ->
      l
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def part1(jboxes) do
    distances = build_distances(jboxes)

    connections = connect(distances, 10)

    IO.inspect(distances)
    IO.inspect(connections, limit: :infinity)

    # connections |> Enum.group_by(fn {_jbox, group} -> group end) |> IO.inspect()
  end

  def connect(distances, limit) do
    Stream.unfold({0, [], distances}, fn {it, groups, distances} ->
      {{_distance, jbox_a, jbox_b}, next_distances} = distances |> List.pop_at(0)

      {status, next_groups} =
        case {find_group(groups, jbox_a), find_group(groups, jbox_b)} do
          # Junction boxes are not connected to anything. 
          {nil, nil} ->
            {:ok, [MapSet.new([jbox_a, jbox_b]) | groups]}

          # Junction boxes are already connected to each other.
          {{idx, _}, {idx, _}} ->
            {:noop, groups}

          # One junction box is already connected, the other is not.
          {{idx, group}, nil} ->
            {:ok, List.replace_at(groups, idx, MapSet.put(group, jbox_b))}

          {nil, {idx, group}} ->
            {:ok, List.replace_at(groups, idx, MapSet.put(group, jbox_a))}

          # Both junction boxes are connected, but in different groups.
          {{idx_a, group_a}, {idx_b, group_b}} ->
            {:ok,
             [
               MapSet.union(group_a, group_b)
               | groups |> List.delete_at(idx_a) |> List.delete_at(idx_b)
             ]}
        end

      next_it =
        case status do
          :ok -> it + 1
          :noop -> it
        end

      if next_it > limit do
        nil
      else
        {next_it, next_groups, next_distances}
      end
    end)
  end

  def find_group(groups, jbox) do
    case Enum.find_index(groups, &MapSet.member?(&1, jbox)) do
      nil -> nil
      idx -> {idx, Enum.at(groups, idx)}
    end
  end

  def build_distances(jboxes) do
    jboxes
    |> Enum.flat_map(fn jbox -> build_distances(jbox, jboxes) end)
    |> Enum.sort_by(fn {distance, _, _} -> distance end)
  end

  def build_distances(jbox, jboxes) do
    jboxes
    |> Enum.take_while(&(&1 != jbox))
    |> Enum.map(fn jbox_b -> {distance(jbox, jbox_b), jbox, jbox_b} end)
  end

  def distance({x1, y1, z1}, {x2, y2, z2}) do
    ((x2 - x1) ** 2 + (y2 - y1) ** 2 + (z2 - z1) ** 2) ** 0.5
  end
end
