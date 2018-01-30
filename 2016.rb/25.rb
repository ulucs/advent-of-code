input = 'cpy a d
cpy 4 c
cpy 643 b
inc d
dec b
jnz b -2
dec c
jnz c -5
cpy d a
jnz 0 0
cpy a b
cpy 0 a
cpy 2 c
jnz b 2
jnz 1 6
dec b
dec c
jnz c -4
inc a
jnz 1 -7
cpy 2 b
jnz c 2
jnz 1 4
dec b
dec c
jnz 1 -4
jnz 0 0
out b
jnz a -19
jnz 1 -21'

# puts a + 2572

class String
  def i?
    /\A[-+]?\d+\z/ === self
  end
end

class Parser
  def initialize(i)
    @registers = Hash.new(0)
    @registers['a'] = i
    @out = ''
    @line = 0
  end

  def parse_line(line)
    # puts @registers if @line == 9
    inst, frm, to = line.split ' '
    frm_val = frm.i? ? frm.to_i : @registers[frm]
    to_val = to.i? ? to.to_i : @registers[to] if to
    case inst
    when 'cpy'
      @registers[to] = frm_val
    when 'inc'
      @registers[frm] += 1
    when 'dec'
      @registers[frm] -= 1
    when 'out'
      @out << frm_val.to_s
      puts @out.reverse.to_i(2) if @registers['a'].zero?
      @line = 1e3 if @registers['a'].zero?
    when 'jnz'
      @line += to_val - 1 if frm_val != 0
    end
    @line += 1
  end

  def parse_lines(lines)
    line_str = lines.split "\n"
    parse_line line_str[@line] until @line >= line_str.size
    puts @registers['a']
  end
end

(0..5).each do |i|
  parser = Parser.new(i)
  puts "#{i}:"
  parser.parse_lines input
end

puts "010101010101"
puts "010101010101".reverse.to_i(2) - 2572
