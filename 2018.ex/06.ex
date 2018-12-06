require AoCUtils

defmodule Day6 do
  def mhttn([a, b], [c, d]) do
    abs(a - c) + abs(b - d)
  end

  def get_closest(x0, x1, y0, y1, points) do
    map_coords(x0, x1, y0, y1, fn x, y ->
      with dists <- Enum.map(points, fn j -> {j, mhttn([x, y], j)} end),
           {mj, min_d} <- Enum.min_by(dists, fn {_, v} -> v end),
           1 <- Enum.count(dists, fn {_, v} -> v == min_d end) do
        mj
      else
        _ -> nil
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> AoCUtils.count_each()
  end

  def get_total_dist(x0, x1, y0, y1, points) do
    map_coords(x0, x1, y0, y1, fn x, y ->
      Enum.map(points, fn j -> mhttn([x, y], j) end)
      |> Enum.sum()
    end)
  end

  def map_coords(x0, x1, y0, y1, f) do
    Stream.flat_map(x0..x1, fn x ->
      Stream.map(y0..y1, fn y ->
        f.(x, y)
      end)
    end)
  end

  def get_bounds(points) do
    {x0, x1} =
      points
      |> Enum.map(fn x -> Enum.fetch!(x, 0) end)
      |> Enum.min_max()

    {y0, y1} =
      points
      |> Enum.map(fn x -> Enum.fetch!(x, 1) end)
      |> Enum.min_max()

    {x0, x1, y0, y1}
  end

  def parse_in(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn x ->
      String.split(x, ", ")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def silver(input) do
    points = parse_in(input)
    {x0, x1, y0, y1} = get_bounds(points)
    ex_map = get_closest(x0 - 10, x1 + 10, y0 - 10, y1 + 10, points)

    get_closest(x0, x1, y0, y1, points)
    |> Enum.filter(fn {k, v} -> Map.fetch!(ex_map, k) == v end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.max()
  end

  def gold(input) do
    points = parse_in(input)
    {x0, x1, y0, y1} = get_bounds(points)

    get_total_dist(x0 - 10, x1 + 10, y0 - 10, y1 + 10, points)
    |> Enum.filter(&(&1 < 10000))
    |> Enum.count()
  end
end

AoCUtils.run_solutions('6', &Day6.silver/1, &Day6.gold/1)
