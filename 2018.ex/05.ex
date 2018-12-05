require AoCUtils

defmodule Day5 do
  def poly_reducer(next, [mid | tail]) do
    if abs(next - mid) == 32 do
      tail
    else
      [next, mid | tail]
    end
  end

  def poly_reducer(next, []) do
    [next]
  end

  def silver(input) do
    input
    |> String.to_charlist()
    |> Enum.reduce([], &poly_reducer/2)
    |> Enum.count()
  end

  def gold(input) do
    cinput = String.to_charlist(input)

    65..90
    |> Enum.map(fn c ->
      cinput
      |> Enum.reject(&(&1 == c || &1 - c == 32))
      |> Enum.reduce([], &poly_reducer/2)
      |> Enum.count()
    end)
    |> Enum.min()
  end
end

AoCUtils.run_solutions('5', &Day5.silver/1, &Day5.gold/1)
