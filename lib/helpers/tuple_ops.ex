defmodule Helpers.TupleOps do
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
        s_scalar = Macro.var(:s, nil)

        add_tuple =
          {:{}, [],
           Enum.zip(a_vars, b_vars)
           |> Enum.map(fn {a, b} -> {:+, meta, [a, b]} end)}

        mul_tuple =
          {:{}, [],
           Enum.zip(a_vars, b_vars)
           |> Enum.map(fn {a, b} -> {:*, meta, [a, b]} end)}
        
        mac_tuple_tuple_scalar =
          {:{}, [],
           Enum.zip(a_vars, b_vars)
           |> Enum.map(fn {a, b} -> {:+, meta, [a, {:*, meta, [b, s_scalar]}]} end)}

        mul_scalar =
          {:{}, [],
           a_vars
           |> Enum.map(fn a -> {:*, meta, [a, s_scalar]} end)}

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
          def mul(unquote(a_tuple), unquote(b_tuple)), do: unquote(mul_tuple)
          def mul(unquote(a_tuple), unquote(s_scalar)), do: unquote(mul_scalar)
          def sub(unquote(a_tuple), unquote(b_tuple)), do: unquote(sub_tuple)
          def mac(unquote(a_tuple), unquote(b_tuple), unquote(s_scalar)), do: unquote(mac_tuple_tuple_scalar)
          def greater_than?(unquote(a_tuple), unquote(b_tuple)), do: unquote(any_tuple)
        end
      end

    quote do
      (unquote_splicing(blocks))
    end
  end
end
