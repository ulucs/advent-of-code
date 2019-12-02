require AoCUtils

defmodule Day1 do
  def silver(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def gold(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Stream.cycle()
    |> Enum.reduce_while(
      {0, MapSet.new([0])},
      fn del, {fq, acc} ->
        if MapSet.member?(acc, del + fq) do
          {:halt, del + fq}
        else
          {:cont, {del + fq, MapSet.put(acc, del + fq)}}
        end
      end
    )
  end
end

AoCUtils.run_solutions('1', &Day1.silver/1, &Day1.gold/1)
