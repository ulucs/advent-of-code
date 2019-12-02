input = File.read('./04input.txt')

idsum = 0
input.lines.each do |line|
  hash = line.slice!(-7, 5)
  id = line[/[0-9]+/].to_i

  counts = line
           .scan(/[a-z]/)
           .sort
           .each_with_object(Hash.new(0)) { |word, cts| cts[word] += 1 }
  sorted_hash = counts
                .keys
                .sort { |a, b| 2 * (counts[b] - counts[a]) + (a <=> b) }
                .take(5)
                .join('')
  idsum += id if hash == sorted_hash

  decrypted = line
              .codepoints
              .map { |c| (97..122).cover?(c) ? ((c + id - 97) % 26) + 97 : 32 }
              .pack('c*')

  puts id if decrypted =~ /north.*pole.*object/
end

puts idsum
