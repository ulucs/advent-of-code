require AoCUtils

defmodule Day2 do
	def count_each list do
		list 
		|> Enum.reduce(%{}, &add_count/2)
	end

	def add_count item, map do
		with {:ok, ct} <- Map.fetch(map, item) do
			%{map | item => ct + 1}
    else _ ->
      Map.put(map, item, 1)
    end
	end

  def lhvstn str1, str2 do
    Enum.zip(
      String.to_charlist(str1),
      String.to_charlist(str2)
    )
    |> Enum.count(fn {a, b} -> a != b end)
  end

  def silver input do
    letter_cts = input
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&count_each/1)
    |> Enum.map(&Map.values/1)
    |> Enum.map(&Enum.uniq/1)

    two_cts = letter_cts
    |> Enum.count(fn cts -> Enum.member?(cts, 2) end)
    three_cts = letter_cts
    |> Enum.count(fn cts -> Enum.member?(cts, 3) end)

    two_cts * three_cts
  end

  def gold input do
    boxes = String.split(input, "\n")

    boxes
    |> Enum.filter(fn box -> 
      boxes
      |> Enum.map(fn bx -> lhvstn(box, bx) end)
      |> Enum.member?(1)
    end)
  end
end

AoCUtils.run_solutions('2', &Day2.silver/1, &Day2.gold/1)