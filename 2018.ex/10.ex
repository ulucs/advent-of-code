require AoCUtils

defmodule Day10 do
  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(~r{[^0-9\-]+}, trim: true)
      |> Enum.map(&String.to_integer/1)
      |> (fn [x1, x2, v1, v2] -> %{pos: {x1, x2}, vel: {v1, v2}} end).()
    end)
  end

  def pos_ranges(points) do
    {min1, max1} =
      points
      |> Enum.map(&elem(&1.pos, 0))
      |> Enum.min_max()

    {min2, max2} =
      points
      |> Enum.map(&elem(&1.pos, 1))
      |> Enum.min_max()

    {min1..max1, min2..max2}
  end

  def print_map(points) do
    {rx, ry} = pos_ranges(points)

    pt_set =
      points
      |> Enum.map(& &1.pos)
      |> MapSet.new()

    Enum.map(ry, fn y ->
      Enum.map(rx, fn x ->
        if MapSet.member?(pt_set, {x, y}), do: "#", else: " "
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
  end

  def timestep(points, t) do
    {_, ry} = pos_ranges(points)
    timestep(points, t, ry)
  end

  def timestep(points, t, ry) do
    new_points =
      points
      |> Enum.map(fn %{pos: {x1, x2}, vel: {v1, v2}} ->
        %{pos: {x1 + v1, x2 + v2}, vel: {v1, v2}}
      end)

    {_, ny} = pos_ranges(new_points)

    if Enum.count(ny) < Enum.count(ry) do
      timestep(new_points, t + 1)
    else
      {t, print_map(points)}
    end
  end

  def silver(input) do
    {t, map} =
      input
      |> parse_input
      |> timestep(0)

    IO.puts(map)
    t
  end
end

AoCUtils.run_solutions('10', &Day10.silver/1)
