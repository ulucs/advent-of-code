require AoCUtils

defmodule Day7 do
  def parse_in(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn x -> Regex.scan(~r{\b[A-Z]\b}, x) end)
    |> Enum.reduce(%{}, fn [[req], [pck]], acc ->
      with {:ok, v} <- Map.fetch(acc, pck) do
        %{acc | pck => MapSet.put(v, req)}
      else
        _ ->
          Map.put(acc, pck, MapSet.new([req]))
      end
    end)
    |> Map.put("P", MapSet.new())
    |> Map.put("Q", MapSet.new())
    |> Map.put("W", MapSet.new())
  end

  def run_dep_tree(deps, order) when deps == %{} do
    order
  end

  def run_dep_tree(deps, order) do
    {to_i, _} =
      deps
      |> Enum.find(fn {_, v} -> MapSet.size(v) == 0 end)

    deps
    |> Map.delete(to_i)
    |> Map.new(fn {k, v} -> {k, MapSet.delete(v, to_i)} end)
    |> run_dep_tree([to_i | order])
  end

  def wp(l) do
    {l, String.to_integer(l, 36) - 9 + 60}
  end

  def worker(work) do
    {queue, active} = Enum.split(work, -5)

    {done, not_d} =
      active
      |> Enum.map(fn {k, v} -> {k, v - 1} end)
      |> Enum.split_with(fn {_, v} -> v == 0 end)

    {done, queue ++ not_d}
  end

  def par_dep_tree(deps, [], t) when deps == %{} do
    t - 1
  end

  def par_dep_tree(deps, work, t) do
    {finished, nwork} = worker(work)

    {to_work, ndeps} =
      finished
      |> Enum.map(fn x -> elem(x, 0) end)
      |> Enum.reduce(deps, fn to_i, acc ->
        acc
        |> Map.delete(to_i)
        |> Map.new(fn {k, v} -> {k, MapSet.delete(v, to_i)} end)
      end)
      |> (fn dtre ->
            Map.split(
              dtre,
              dtre
              |> Enum.filter(fn {_, v} -> MapSet.size(v) == 0 end)
              |> Enum.map(&elem(&1, 0))
            )
          end).()

    tw =
      to_work
      |> Enum.reverse()
      |> Enum.map(&elem(&1, 0))
      |> Enum.map(&wp/1)

    par_dep_tree(ndeps, tw ++ nwork, t + 1)
  end

  def silver(input) do
    input
    |> parse_in
    |> run_dep_tree([])
    |> Enum.reverse()
    |> Enum.join("")
  end

  def gold(input) do
    input
    |> parse_in
    |> par_dep_tree([], 0)
  end
end

AoCUtils.run_solutions('7', &Day7.silver/1, &Day7.gold/1)
