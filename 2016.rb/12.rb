input = 'cpy 1 a
cpy 1 b
cpy 26 d
jnz c 2
jnz 1 5
cpy 7 c
inc d
dec c
jnz c -2
cpy a c
inc a
dec b
jnz b -2
cpy c b
dec d
jnz d -6
cpy 19 c
cpy 14 d
inc a
dec d
jnz d -2
dec c
jnz c -5'

test = 'cpy 41 a
inc a
inc a
dec a
jnz a 2
dec a'

class String
  def i?
    /\A[-+]?\d+\z/ === self
  end
end

class Parser
  def initialize
    @registers = Hash.new(0)
    @registers['c'] = 1
    @line = 0
  end

  def parse_line(line)
    puts @registers if @line == 9
    inst, frm, to = line.split ' '
    frm_val = frm.i? ? frm.to_i : @registers[frm]
    case inst
    when 'cpy'
      @registers[to] = frm_val
    when 'inc'
      @registers[frm] += 1
    when 'dec'
      @registers[frm] -= 1
    when 'jnz'
      @line += to.to_i - 1 if frm_val != 0
    end
    @line += 1
  end

  def parse_lines(lines)
    line_str = lines.split "\n"
    parse_line line_str[@line] until @line >= line_str.size
    puts @registers['a']
  end
end

def fib n
  fstr = [1, 1]
  while fstr.size <= n + 1
    fstr.push fstr[-1] + fstr[-2]
  end
  fstr.last
end

parser = Parser.new
# parser.parse_lines input

puts fib(26) + 266
puts fib(33) + 266
