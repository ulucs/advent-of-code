input = File.read('./06input.txt')

def count_els(chars)
  chars.each_with_object(Hash.new(0)) { |word, cts| cts[word] += 1 }
end

counts = input
         .lines
         .map(&:chars)
         .transpose
         .map(&method(:count_els))

phrase = counts.map { |cts| cts.keys.max { |a, b| (cts[a] - cts[b]) } }
               .join ''

phrase2 = counts.map { |cts| cts.keys.max { |a, b| (cts[b] - cts[a]) } }
                .join ''

puts phrase
puts phrase2
