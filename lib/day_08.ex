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

  def part1(jboxes, rounds) do
    jboxes
    |> build_distances()
    |> connect(rounds)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def connect(distances, rounds) do
    distances
    |> Enum.take(rounds)
    |> Enum.reduce(
      [],
      fn {_distance, jbox_a, jbox_b}, groups ->
        case {find_group(groups, jbox_a), find_group(groups, jbox_b)} do
          # Junction boxes are not connected to anything. 
          {nil, nil} -> [MapSet.new([jbox_a, jbox_b]) | groups]
          # Junction boxes are already connected to each other.
          {idx, idx} -> groups
          # One junction box is already connected, the other is not.
          {idx, nil} -> add_to_group(groups, idx, jbox_b)
          {nil, idx} -> add_to_group(groups, idx, jbox_a)
          # Both junction boxes are connected, but in different groups.
          {idx_a, idx_b} -> merge_groups(groups, idx_a, idx_b)
        end
      end
    )
  end

  def connect_re(distances, limit), do: connect_re(distances, limit, [])

  def connect_re(_distances, limit, groups) when limit <= 0, do: groups

  def connect_re(distances, limit, groups) do
    {{_distance, jbox_a, jbox_b}, next_distances} = distances |> List.pop_at(0)

    next_groups =
      case {find_group(groups, jbox_a), find_group(groups, jbox_b)} do
        # Junction boxes are not connected to anything. 
        {nil, nil} -> [MapSet.new([jbox_a, jbox_b]) | groups]
        # Junction boxes are already connected to each other.
        {idx, idx} -> groups
        # One junction box is already connected, the other is not.
        {idx, nil} -> add_to_group(groups, idx, jbox_b)
        {nil, idx} -> add_to_group(groups, idx, jbox_a)
        # Both junction boxes are connected, but in different groups.
        {idx_a, idx_b} -> merge_groups(groups, idx_a, idx_b)
      end

    connect_re(next_distances, limit - 1, next_groups)
  end

  def merge_groups(groups, idx_a, idx_b) do
    group_a = Enum.at(groups, idx_a)
    group_b = Enum.at(groups, idx_b)

    [
      MapSet.union(group_a, group_b)
      | groups |> List.delete_at(max(idx_a, idx_b)) |> List.delete_at(min(idx_a, idx_b))
    ]
  end

  def add_to_group(groups, idx, jbox) do
    group = Enum.at(groups, idx)
    List.replace_at(groups, idx, MapSet.put(group, jbox))
  end

  def find_group(groups, jbox) do
    Enum.find_index(groups, &MapSet.member?(&1, jbox))
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
