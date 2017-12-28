input = File.read('./03input.txt')

def scan(line)
  line.scan(/[0-9]+/).map(&:to_i)
end

def trig?(line)
  a, b, c = line.scan(/[0-9]+/).map(&:to_i).sort
  c < a + b ? 1 : 0
end

trigs = input.lines.map { |line| trig? line }
puts trigs.sum

trigs2 = input
         .lines
         .map { |l| scan(l) }
         .each_slice(3)
         .to_a
         .map(&:transpose)
         .flatten(1)
         .map(&:sort)
         .map { |a, b, c| c < a + b ? 1 : 0 }
puts trigs2.sum
