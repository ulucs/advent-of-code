class String
  def trap?(i)
    l = i>=1 ? self[i-1] : nil
    c = self[i]
    r = self[i+1]
    (l == '^' && c == '^' && r != '^') ||
      (l != '^' && c == '^' && r == '^') ||
      (l == '^' && c != '^' && r != '^') ||
      (l != '^' && c != '^' && r == '^')
  end

  def next_line
    line = ''
    (0...length).each {|i| line << (trap?(i) ? '^' : '.')}
    line
  end
end

lines = ['.^^^.^.^^^^^..^^^..^..^..^^..^.^.^.^^.^^....^.' \
  '^...^.^^.^^.^^..^^..^.^..^^^.^^...^...^^....^^.^^^^^^^']

39.times do
  lines << lines.last.next_line
end

puts lines.inject(0) {|sum, line| sum + line.count('.')}

cts = 0
nx_ln = lines.first
400_000.times do
  cts += nx_ln.count('.')
  nx_ln = nx_ln.next_line
end

puts cts