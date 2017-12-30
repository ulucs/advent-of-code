require 'digest'

input = 'reyedfim'
output = ''
oc = []

(1..Float::INFINITY).each do |num|
  hash = Digest::MD5.hexdigest input + num.to_s
  next unless hash[0..4] == '00000'
  output += hash[5]
  break if output.length == 8
end

puts output

(1..Float::INFINITY).each do |num|
  hash = Digest::MD5.hexdigest input + num.to_s
  next unless hash[0..4] == '00000' && ('0'..'7').cover?(hash[5])
  ind = hash[5].to_i
  char = hash[6]
  oc[ind] ||= char
  break unless oc.any?(&:nil?)
end

puts oc * ''
