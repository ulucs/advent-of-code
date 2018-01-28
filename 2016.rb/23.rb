input = 'cpy a b
dec b
cpy a d
cpy 0 a
cpy b c
inc a
dec c
jnz c -2
dec d
jnz d -5
dec b
cpy b c
cpy c d
dec d
inc c
jnz d -2
tgl c
cpy -16 c
jnz 1 c
cpy 81 c
jnz 94 d
inc a
inc d
jnz d -2
inc c
jnz c -5'

test = 'cpy 2 a
tgl a
tgl a
tgl a
cpy 1 a
dec a
dec a'

class String
  def i?
    /\A[-+]?\d+\z/ === self
  end
end

class Parser
  def initialize(i)
    @registers = Hash.new(0)
    @registers['a'] = i
    @toggles = Hash.new(false)
    @line = 0
  end

  def do_line(inst, frm, to, frm_val, to_val)
    case inst
    when 'tgl'
      @toggles[frm_val + @line] ^= true
    when 'cpy'
      @registers[to] = frm_val
    when 'inc'
      @registers[frm] += 1
    when 'dec'
      @registers[frm] -= 1
    when 'jnz'
      @line += to_val - 1 if frm_val != 0
    end
  end

  def do_line_tg(inst, frm, to, frm_val, to_val)
    case inst
    when 'jnz' # cpy
      @registers[to] = frm_val if to.is_a?(String)
    when 'dec', 'tgl' # inc
      @registers[frm] += 1
    when 'inc' # dec
      @registers[frm] -= 1
    when 'cpy' # jnz
      @line += to_val - 1 if frm_val != 0
    end
  end

  def parse_line(line)
    inst, frm, to = line.split ' '
    frm_val = frm.i? ? frm.to_i : @registers[frm]
    to_val = to.i? ? to.to_i : @registers[to] if to
    if @toggles[@line]
      do_line_tg(inst, frm, to, frm_val, to_val)
    else
      do_line(inst, frm, to, frm_val, to_val)
    end
    @line += 1
    puts @registers if @registers['d'].zero?
  end

  def parse_lines(lines)
    line_str = lines.split "\n"
    parse_line line_str[@line] until @line >= line_str.size
    puts @registers['a']
  end
end

def fact(i)
  return 1 if i.zero?
  i * fact(i - 1)
end

parser = Parser.new(7)
parser.parse_lines input

puts fact(7) + 81 * 94
puts fact(12) + 81 * 94
