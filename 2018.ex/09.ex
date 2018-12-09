require AoCUtils

defmodule Day9 do
  def parse_in(input) do
    input
    |> String.split(~r{[^0-9]+}, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def game_turn({pl, mb}, %{board: bd, scores: sc, cur_n: cn}) do
    if Integer.mod(mb, 23) == 0 do
      dn = move(bd, cn, -7)
      {_, nn} = Map.fetch!(bd, dn)

      %{
        scores: Map.update(sc, pl, dn + mb, &(&1 + dn + mb)),
        board: delete(bd, dn),
        cur_n: nn
      }
    else
      ncn = move(bd, cn, 2)

      %{
        scores: sc,
        board: insert(bd, ncn, mb),
        cur_n: mb
      }
    end
  end

  def move(_board, cn, 0) do
    cn
  end

  def move(board, cn, k) do
    {p, n} = Map.fetch!(board, cn)

    if k > 0 do
      move(board, n, k - 1)
    else
      move(board, p, k + 1)
    end
  end

  def delete(board, cn) do
    {p, n} = Map.fetch!(board, cn)
    {pp, _} = Map.fetch!(board, p)
    {_, nn} = Map.fetch!(board, n)

    board
    |> Map.delete(cn)
    |> Map.put(p, {pp, n})
    |> Map.put(n, {p, nn})
  end

  def insert(board, cn, val) do
    {p, n} = Map.fetch!(board, cn)
    {pp, _} = Map.fetch!(board, p)

    board
    |> Map.put(val, {p, cn})
    |> Map.put(cn, {val, n})
    |> Map.put(p, {pp, val})
  end

  def solve([n, last]) do
    2..n
    |> Enum.concat([1])
    |> Stream.cycle()
    |> Stream.take(last)
    |> Stream.zip(2..last)
    |> Enum.reduce(%{board: %{0 => {1, 1}, 1 => {0, 0}}, cur_n: 0, scores: %{}}, &game_turn/2)
    |> Map.fetch!(:scores)
    |> Map.values()
    |> Enum.max()
  end

  def silver(input) do
    parse_in(input)
    |> solve
  end

  def gold(input) do
    [n, last] = parse_in(input)
    solve([n, last * 100000])
  end
end

AoCUtils.run_solutions('9', &Day9.silver/1, &Day9.gold/1)
