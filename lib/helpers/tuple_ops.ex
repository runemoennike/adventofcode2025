defmodule Helpers.TupleOps do
  @moduledoc """
  Generates tuple operations for sizes 1..10:
    * add/2
    * sub/2
    * greater_than?/2
  """

  defmacro __using__(_opts) do
    quote do
      unquote(Helpers.TupleOps.__defs__())
    end
  end

  def __defs__ do
    meta = [context: Elixir, import: Kernel]

    blocks =
      for n <- 1..10 do
        a_vars = for i <- 1..n, do: Macro.var(:"a#{i}", nil)
        b_vars = for i <- 1..n, do: Macro.var(:"b#{i}", nil)

        a_tuple = {:{}, [], a_vars}
        b_tuple = {:{}, [], b_vars}

        add_tuple =
          {:{}, [],
           Enum.zip(a_vars, b_vars)
           |> Enum.map(fn {a, b} -> {:+, meta, [a, b]} end)}

        sub_tuple =
          {:{}, [],
           Enum.zip(a_vars, b_vars)
           |> Enum.map(fn {a, b} -> {:-, meta, [a, b]} end)}

        gt_exprs_tuple =
          Enum.zip(a_vars, b_vars)
          |> Enum.map(fn {a, b} -> {:>, meta, [a, b]} end)

        any_tuple =
          case gt_exprs_tuple do
            [first | rest] -> Enum.reduce(rest, first, fn e, acc -> {:or, meta, [acc, e]} end)
            [] -> false
          end

        quote do
          def add(unquote(a_tuple), unquote(b_tuple)), do: unquote(add_tuple)
          def sub(unquote(a_tuple), unquote(b_tuple)), do: unquote(sub_tuple)
          def greater_than?(unquote(a_tuple), unquote(b_tuple)), do: unquote(any_tuple)
        end
      end

    quote do
      unquote_splicing(blocks)
    end
  end
end
