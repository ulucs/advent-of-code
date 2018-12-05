require AoCUtils

defmodule Day3 do
  def cart_pro(list1, list2) do
    list1
    |> Enum.flat_map(fn it1 ->
      Enum.map(list2, fn it2 -> [it1, it2] end)
    end)
  end

  def expand_claim([_, ox, oy, sx, sy]) do
    cart_pro(
      ox..(ox + sx - 1),
      oy..(oy + sy - 1)
    )
  end

  def silver(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn x ->
      String.split(x, ~r{[^0-9]}, trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.flat_map(&expand_claim/1)
    |> AoCUtils.count_each()
    |> Enum.count(fn {_, v} -> v >= 2 end)
  end

  def gold(input) do
    claims =
      input
      |> String.split("\n")
      |> Enum.map(fn x ->
        String.split(x, ~r{[^0-9]}, trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.flat_map(&expand_claim/1)
      |> AoCUtils.count_each()

    input
    |> String.split("\n")
    |> Enum.map(fn x ->
      String.split(x, ~r{[^0-9]}, trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.reject(fn claim ->
      expand_claim(claim)
      |> Enum.any?(fn sq -> Map.fetch!(claims, sq) > 1 end)
    end)
  end
end

AoCUtils.run_solutions('3', &Day3.silver/1, &Day3.gold/1)
