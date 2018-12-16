require AoCUtils

defmodule Day14 do
  def add_recipe({recipe_list, i1, i2, recipe_count}) do
    [i1, i2] =
      [i1, i2]
      |> Enum.map(&Integer.mod(&1, recipe_count))

    [p1, p2] =
      [i1, i2]
      |> Enum.map(&Map.fetch!(recipe_list, &1))

    [first | any] = Integer.digits(p1 + p2)

    recipe_list = insert(recipe_list, recipe_count, first)

    with [some] <- any do
      {insert(recipe_list, recipe_count + 1, some), i1 + p1 + 1, i2 + p2 + 1, recipe_count + 2}
    else
      _ -> {recipe_list, i1 + p1 + 1, i2 + p2 + 1, recipe_count + 1}
    end
  end

  def insert(board, bsz, val) do
    Map.put(board, bsz, val)
  end

  def get_series(map, initial, size) do
    initial..(initial + size - 1)
    |> Enum.map(&Map.fetch!(map, &1))
    |> Integer.undigits()
  end

  def silver(input) do
    times = String.to_integer(input)

    {map, _, _, map_size} =
      1..1
      |> Stream.cycle()
      |> Enum.reduce_while({%{0 => 3, 1 => 7}, 0, 1, 2}, fn _, acc ->
        {_, _, _, msz} = recipes = add_recipe(acc)

        if msz > times + 9 do
          {:halt, recipes}
        else
          {:cont, recipes}
        end
      end)

    times..(times + 9)
    |> Enum.map(&Map.fetch!(map, &1))
    |> Integer.undigits()
  end

  def gold(input) do
    search = String.to_integer(input)

    1..1_000_000_000
    |> Enum.reduce_while({%{0 => 3, 1 => 7}, 0, 1, 2}, fn _, acc ->
      recipes = add_recipe(acc)
      {map, _, _, msz} = recipes

      if(msz < 10,
        do: {:cont, recipes},
        else:
          cond do
            search == get_series(map, msz - 6, 6) -> {:halt, msz - 7}
            search == get_series(map, msz - 7, 6) -> {:halt, msz - 8}
            true -> {:cont, recipes}
          end
      )
    end)
  end
end

AoCUtils.run_solutions('14', &Day14.silver/1, &Day14.gold/1)
