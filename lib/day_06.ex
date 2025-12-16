defmodule Day06 do
  def p1_parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(
      &(String.trim(&1)
        |> String.split(" ", trim: true)
        |> Enum.map(fn
          "*" -> :multiply
          "+" -> :add
          n -> String.to_integer(n)
        end))
    )
    |> Enum.zip()
    |> Enum.map(fn l ->
      Tuple.to_list(l) |> then(fn l -> [Enum.at(l, -1) | Enum.take(l, length(l) - 1)] end)
    end)
  end

  def part1(computations) do
    computations
    |> Enum.sum_by(fn
      [:add | numbers] -> Enum.sum(numbers)
      [:multiply | numbers] -> Enum.product(numbers)
    end)
  end

  def p2_parse(input) do
    input
    |> String.split("\r\n", trim: true)
    |> then(fn l -> [Enum.at(l, -1) | Enum.take(l, length(l) - 1)] end)
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(fn t ->
      Tuple.to_list(t) |> Enum.join() |> String.replace(" ", "")
    end)
    |> Enum.flat_map(fn
      "*" <> s -> [:multiply, String.to_integer(s)]
      "+" <> s -> [:add, String.to_integer(s)]
      "" -> [:split]
      s -> [String.to_integer(s)]
    end)
    |> Enum.chunk_while(
      [],
      fn
        :split, acc -> {:cont, acc, []}
        el, acc -> {:cont, acc ++ [el]}
      end,
      fn
        [] -> {:cont, []}
        acc -> {:cont, acc, []}
      end
    )
  end

  def part2(computations) do
    computations
    |> Enum.sum_by(fn
      [:add | numbers] -> Enum.sum(numbers)
      [:multiply | numbers] -> Enum.product(numbers)
    end)
  end
end
