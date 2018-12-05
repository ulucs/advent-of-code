require AoCUtils

defmodule Day1 do
  def find_loop_point list do
    find_loop_point list, 0, MapSet.new, list
  end

  def find_loop_point [], freq, acc, olist do
    find_loop_point olist, freq, acc, olist
  end

  def find_loop_point list, freq, acc, olist do
    [item | tail] = list
    new_freq = item + freq
    if MapSet.member?(acc, new_freq) do
      new_freq
    else
      find_loop_point tail, new_freq, MapSet.put(acc, new_freq), olist
    end
  end

  def silver input do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum
  end

  def gold input do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> find_loop_point
  end
end

AoCUtils.run_solutions('1', &Day1.silver/1, &Day1.gold/1)
