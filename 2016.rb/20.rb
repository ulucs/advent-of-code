inputs = File.read('./20input.txt')
             .gsub('-', '..')
             .tr("\n", ',')

ranges = eval "[#{inputs}]"
ranges.sort! { |a, b| a.first - b.first}
merged = ranges.inject([]) do |ar, b|
  a = ar.last
  next [b] unless a
  bra = a.last
  brb = b.first
  next ar << b if bra + 1 < brb
  ar.pop
  ar << (a.first..[bra, b.last].max)
end

puts merged.first

allowed = merged.inject([]) do |ar, b|
  a = ar.last
  next [0, b] unless a
  st = a.last + 1
  ed = b.first
  [ar.first + ed - st, b]
end

puts allowed.first

