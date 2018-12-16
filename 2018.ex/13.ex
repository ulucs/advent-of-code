require AoCUtils

defmodule Day13 do
  @mv %{right: {0, 1}, left: {0, -1}, up: {-1, 0}, down: {1, 0}}

  def dir_of cart do
    case cart do
      ?> -> @mv.right
      ?< -> @mv.left
      ?^ -> @mv.up
      ?v -> @mv.down
    end
  end

  def cross({{d1, d2} = current, turn_dir}) do
    case turn_dir do
      :straight -> {current, :right}
      :left -> {{-d2, d1}, :straight}
      :right -> {{d2, -d1}, :left}
    end
  end
  
  def sway(tile, {current_dir, next_turn} = cart) do
    case {tile, current_dir} do
      {?\\, unquote(@mv.left)} -> {@mv.up, next_turn}
      {?\\, unquote(@mv.right)} -> {@mv.down, next_turn}
      {?\\, unquote(@mv.down)} -> {@mv.right, next_turn}
      {?\\, unquote(@mv.up)} -> {@mv.left, next_turn}

      {?/, unquote(@mv.left)} -> {@mv.down, next_turn}
      {?/, unquote(@mv.right)} -> {@mv.up, next_turn}
      {?/, unquote(@mv.down)} -> {@mv.left, next_turn}
      {?/, unquote(@mv.up)} -> {@mv.right, next_turn}

      {?., _} -> {current_dir, next_turn}
      {?+, _} -> cross(cart)
    end
  end

  def move_carts carts, map do
    positions = MapSet.new(elem(Enum.unzip(carts), 0))

    {_, collisions, new_carts} =
      carts
      |> Enum.reduce({positions, [], []}, fn cart, {pos, col, carts} ->
        {{x1, x2}, {{d1, d2}, _} = cart_m} = cart
        new_pos = {x1 + d1, x2 + d2}
        new_mov = sway(Map.fetch!(map, new_pos), cart_m)

        pos = MapSet.delete(pos, {x1, x2})
        col = if MapSet.member?(pos, new_pos), do: [new_pos | col], else: col
        pos = MapSet.put(pos, new_pos)

        {pos, col, [{new_pos, new_mov} | carts]}
      end)
    
    {Enum.sort(new_carts), collisions}
  end

  def move_re_carts carts, map do
    positions = MapSet.new(elem(Enum.unzip(carts), 0))

    {_, collisions, new_carts} =
      carts
      |> Enum.reduce({positions, MapSet.new, []}, fn cart, {pos, col, carts} ->
        {{x1, x2}, {{d1, d2}, _} = cart_m} = cart
        if {x1, x2} in col do
          {pos, col, carts}
        else
          new_pos = {x1 + d1, x2 + d2}
          new_mov = sway(Map.fetch!(map, new_pos), cart_m)
          pos = MapSet.delete(pos, {x1, x2})
          if new_pos in pos do
            {pos, MapSet.put(col, new_pos), carts}
          else
            {MapSet.put(pos, new_pos), col, [{new_pos, new_mov} | carts]}
          end
        end
      end)
    
    new_carts
    |> Enum.filter(fn {pos, _} -> pos not in collisions end)
    |> Enum.sort
  end

  def parse_in input do
    input
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.map(fn {row, x} ->
      row
      |> String.to_charlist
      |> Enum.with_index
      |> Enum.filter(fn {c, _} -> c != ?\s end)
      |> Enum.reduce({[], []}, fn {tile, y}, {map, carts} ->
        {
          [{{x, y}, if(tile in '<>^v-|', do: ?., else: tile)} | map],
          if(tile in '><^v', do: [{{x, y}, {dir_of(tile), :left}} | carts], else: carts)
        }
      end)
    end)
    |> Enum.unzip
    |> (fn {map, carts} ->
      {
        map |> Enum.concat |> Map.new,
        carts |> Enum.concat |> Enum.sort
      }
    end).()
  end

  def silver input do
    {map, carts} = parse_in(input)

    1..1_000_000
    |> Enum.reduce_while(carts, fn i, cl ->
      with {new_carts, []} <- move_carts(cl, map) do
        {:cont, new_carts}
      else {_, cols} -> {:halt, {i, Enum.reverse(cols)}}
      end
    end)
  end

  def gold input do
    {map, carts} = parse_in(input)

    1..1_000_000
    |> Enum.reduce_while(carts, fn _, cl ->
      with [cart] <- move_re_carts(cl, map) do
        {:halt, cart}
      else carts -> {:cont, carts}
      end
    end)
  end
end

AoCUtils.run_solutions('13', &Day13.silver/1, &Day13.gold/1)
