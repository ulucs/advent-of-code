require AoCUtils

defmodule Day8 do
  def parse_childs(0, rest) do
    {[], rest}
  end

  def parse_childs(cc, [children, mtct | tail]) do
    {chd, rest} = parse_childs(children, tail)
    {meta, other} = Enum.split(rest, mtct)
    {sib, rem} = parse_childs(cc - 1, other)

    {
      [%{childs: chd, metadata: meta, cc: children} | sib],
      rem
    }
  end

  def parse_nodes([]) do
    []
  end

  def parse_nodes([children, mtct | tail]) do
    {chd, rest} = parse_childs(children, tail)
    {meta, other} = Enum.split(rest, mtct)

    [
      %{childs: chd, metadata: meta, cc: children}
      | parse_nodes(other)
    ]
  end

  def sum_meta([]) do
    0
  end

  def sum_meta([node | tail]) do
    Enum.sum(node.metadata) + sum_meta(node.childs) + sum_meta(tail)
  end

  def comp_sum(%{childs: [], metadata: meta}) do
    Enum.sum(meta)
  end

  def comp_sum(%{childs: chd, metadata: meta}) do
    meta
    |> Enum.map(fn mt ->
      with {:ok, child} <- Enum.fetch(chd, mt - 1) do
        comp_sum(child)
      else
        _ -> 0
      end
    end)
    |> Enum.sum()
  end

  def parse_in(input) do
    input
    |> String.split(~r{\s}, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> parse_nodes
  end

  def silver(input) do
    input
    |> parse_in
    |> sum_meta
  end

  def gold(input) do
    input
    |> parse_in
    |> Enum.fetch!(0)
    |> comp_sum
  end
end

AoCUtils.run_solutions('8', &Day8.silver/1, &Day8.gold/1)
