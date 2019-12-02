require AoCUtils
require Integer

defmodule Day12 do
  def parse_in(input) do
    [init, _ | rules] = String.split(input, "\n")

    {
      init
      |> String.split(~r{[^#.]+}, trim: true)
      |> Enum.fetch!(0)
      |> String.to_charlist(),
      rules
      |> Enum.map(fn s -> String.split(s, " => ") end)
      |> Enum.map(fn [a, b] ->
        {
          String.to_charlist(a),
          Enum.fetch!(String.to_charlist(b), 0)
        }
      end)
      |> Map.new()
    }
  end

  def flower_score(flw) do
    flw
    |> Enum.map(fn {c, i} -> if c == ?#, do: i, else: 0 end)
    |> Enum.sum()
  end

  def flower({[{?., _i}, {?., _i1}, {?., _i2}], [?., ?.]}, _rules) do
    []
  end

  def flower({[{t2, i}], [t1, t0]}, rules) do
    flower({[{t2, i}, {?., i + 1}, {?., i + 2}], [t1, t0]}, rules)
  end

  def flower({[{t2, i}, c3], [t1, t0]}, rules) do
    flower({[{t2, i}, c3, {?., i + 2}], [t1, t0]}, rules)
  end

  def flower({[{t2, i}, {t3, i1}, {t4, i2} | tail], [t1, t0]}, rules) do
    ptch = [t0, t1, t2, t3, t4]

    [
      {Map.fetch!(rules, ptch), i}
      | flower({[{t3, i1}, {t4, i2} | tail], [t2, t1]}, rules)
    ]
  end

  def silver(input) do
    {init, rules} = parse_in(input)
    turns = 20

    1..turns
    |> Enum.reduce(Enum.with_index(init), fn _, h ->
      with [{_, fi} | _] <- h do
        flower({[{?., fi - 2}, {?., fi - 1} | h], '..'}, rules)
        |> Enum.drop_while(fn {c, _} -> c == ?# end)
      end
    end)
    |> flower_score
  end

  def gold(input) do
    {init, rules} = parse_in(input)
    turns = 50_000_000_000

    1..turns
    |> Enum.reduce_while({Enum.with_index(init), 0}, fn i, {h, _} ->
      {old_patch, _} = Enum.unzip(h)
      [{_, fi} | _] = h

      new_acc =
        flower({[{?., fi - 2}, {?., fi - 1} | h], '..'}, rules)
        |> Enum.drop_while(fn {c, _} -> c == ?. end)

      if old_patch == elem(Enum.unzip(new_acc), 0) do
        turn_diff = flower_score(new_acc) - flower_score(h)
        base = flower_score(new_acc) - turn_diff * i
        {:halt, turns * turn_diff + base}
      else
        {:cont, {new_acc, i}}
      end
    end)
  end
end

AoCUtils.run_solutions('12', &Day12.silver/1, &Day12.gold/1)
