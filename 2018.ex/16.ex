require AoCUtils
use Bitwise

defmodule Day16 do
  @ops %{
    0 => :muli,
    1 => :seti,
    2 => :bani,
    3 => :gtri,
    4 => :gtrr,
    5 => :eqrr,
    6 => :addi,
    7 => :gtir,
    8 => :eqir,
    9 => :mulr,
    10 => :addr,
    11 => :borr,
    12 => :bori,
    13 => :eqri,
    14 => :banr,
    15 => :setr
  }

  def b2i(x), do: if(x, do: 1, else: 0)

  def wt(f), do: fn {x, y} -> f.(x, y) end

  def rreg1(regs), do: fn {r, y} -> {Map.get(regs, r, 0), y} end

  def rreg2(regs), do: fn {x, r} -> {x, Map.get(regs, r, 0)} end

  def rregb(regs), do: fn {r1, r2} -> {Map.get(regs, r1, 0), Map.get(regs, r2, 0)} end

  def compose(f, g) when is_function(g) do
    fn arg -> compose(f, g.(arg)) end
  end

  def compose(f, arg) do
    f.(arg)
  end

  def f <|> g, do: compose(g, f)

  def runcom(regs, [command, x, y, w]) do
    Map.put(regs, w, opcodes(regs)[command].({x, y}))
  end

  def runops(regs, [cno | rest]) do
    runcom(regs, [@ops[cno] | rest])
  end

  def opcodes(reg),
    do: %{
      addr: rregb(reg) <|> wt(&+/2),
      addi: rreg1(reg) <|> wt(&+/2),
      mulr: rregb(reg) <|> wt(&*/2),
      muli: rreg1(reg) <|> wt(&*/2),
      banr: rregb(reg) <|> wt(& &&&/2),
      bani: rreg1(reg) <|> wt(& &&&/2),
      borr: rregb(reg) <|> wt(&|||/2),
      bori: rreg1(reg) <|> wt(&|||/2),
      setr: rreg1(reg) <|> (&elem(&1, 0)),
      seti: &elem(&1, 0),
      gtrr: rregb(reg) <|> wt(&>/2) <|> (&b2i/1),
      gtri: rreg1(reg) <|> wt(&>/2) <|> (&b2i/1),
      gtir: rreg2(reg) <|> wt(&>/2) <|> (&b2i/1),
      eqrr: rregb(reg) <|> wt(&==/2) <|> (&b2i/1),
      eqri: rreg1(reg) <|> wt(&==/2) <|> (&b2i/1),
      eqir: rreg2(reg) <|> wt(&==/2) <|> (&b2i/1)
    }

  def parse_regs(line) do
    line
    |> parse_com
    |> Enum.with_index()
    |> Enum.map(fn {x, y} -> {y, x} end)
    |> Map.new()
  end

  def parse_com(line) do
    line
    |> String.split(~r{\D+}, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def parse_in(input) do
    [f, b] = String.split(input, "\n\n\n")

    {
      String.split(f, "\n")
      |> Enum.chunk_every(4)
      |> Enum.map(fn [r1, c, r2 | _] ->
        %{
          bf: parse_regs(r1),
          af: parse_regs(r2),
          args: parse_com(c)
        }
      end),
      String.split(b, "\n", trim: true)
      |> Enum.map(&parse_com/1)
    }
  end

  def silver(input) do
    {fp, _} = parse_in(input)

    ops =
      opcodes(%{})
      |> Map.keys()

    fp
    |> Enum.reduce(0, fn %{bf: b, af: a, args: [_c | rst]}, poss ->
      opts =
        ops
        # Map.get(poss, c, ops)
        |> Enum.filter(fn op ->
          a == runcom(b, [op | rst])
        end)
        # |> MapSet.new()
        |> Enum.count()

      poss + b2i(opts >= 3)
      # Map.update(poss, c, opts, &(MapSet.intersection(&1, opts)))
    end)

    # |> Map.values
    # |> Enum.filter(&(MapSet.size(&1) >= 3))
    # |> Enum.count
  end

  def gold(input) do
    {_, coms} = parse_in(input)

    coms
    |> Enum.reduce(%{}, fn cms, reg ->
      runops(reg, cms)
    end)
  end
end

AoCUtils.run_solutions('16', &Day16.silver/1, &Day16.gold/1)
