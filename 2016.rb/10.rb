input = File.read('./10input.txt')
test = 'value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2'

class Distributer
  def initialize
    @bots_outs = Hash.new { [] }
  end

  def dist(subj, obj1, obj2)
    lo, hi = @bots_outs[subj].sort
    return if hi.nil?
    # puts subj if [lo, hi] == [17, 61]
    @bots_outs[obj1] <<= lo
    @bots_outs[obj2] <<= hi
    @bots_outs[subj] = []
  end

  def assign(val, obj)
    v = val[/[0-9]+/].to_i
    @bots_outs[obj] <<= v
  end

  def parse_line(line)
    subj, obj1, obj2 = line.scan(/\S+ [0-9]+/)
    assign(subj, obj1) if obj2.nil?
    dist(subj, obj1, obj2) unless obj2.nil?
  end

  def print_mult
    v0 = @bots_outs['output 0'].last
    v1 = @bots_outs['output 1'].last
    v2 = @bots_outs['output 2'].last
    return if [v0, v1, v2].any?(&:nil?)
    puts v0 * v1 * v2
    exit
  end

  def parse_lines(lines)
    loop do
      lines.each_line { |line| parse_line line }
      print_mult
    end
  end
end

dist = Distributer.new
dist.parse_lines input
