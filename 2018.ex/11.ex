require AoCUtils

defmodule Day11 do
  def parse_in(input) do
    ser = String.to_integer(input)

    Enum.map(1..300, fn x ->
      Enum.reduce(1..300, %{}, fn y, acc ->
        Map.put(acc, {x, y}, calc_batt(x, y, ser))
      end)
    end)
    |> Enum.reduce(&Map.merge/2)
  end

  def calc_batt(x, y, ser) do
    Integer.mod(div(((x + 10) * y + ser) * (x + 10), 100), 10) - 5
  end

  def silver(input) do
    batteries = parse_in(input)

    Enum.flat_map(1..298, fn x ->
      Enum.map(1..298, fn y -> {x, y} end)
    end)
    |> Enum.max_by(fn {x, y} ->
      Enum.flat_map(x..(x + 2), fn dx ->
        Enum.map(y..(y + 2), fn dy ->
          Map.fetch!(batteries, {dx, dy})
        end)
      end)
      |> Enum.sum()
    end)
  end

  def gold(input) do
    batteries = parse_in(input)

    Enum.flat_map(1..300, fn x ->
      Enum.flat_map(1..300, fn y ->
        Enum.map(1..min(16, max(300 - max(x, y), 1)), fn r -> {x, y, r} end)
      end)
    end)
    |> Enum.max_by(fn {x, y, r} ->
      Enum.flat_map(x..(x + r - 1), fn dx ->
        Enum.map(y..(y + r - 1), fn dy ->
          Map.fetch!(batteries, {dx, dy})
        end)
      end)
      |> Enum.sum()
    end)
  end
end

AoCUtils.run_solutions('11', &Day11.silver/1, &Day11.gold/1)
