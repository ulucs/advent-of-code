require 'digest'

class HashCode < Array
  @@computed = []

  alias key first
  alias num last

  def digest
    return @@computed[num] if @@computed[num]
    str = Digest::MD5.hexdigest(key + num.to_s)
    # 2016.times { str = Digest::MD5.hexdigest(str) }
    @@computed[num] = str
  end

  def valid?
    sames = digest.match /(.)\1\1/
    return false unless sames
    chars = sames.captures.first * 5
    (1..1000).each do |i|
      new_code = HashCode.new([key, num + i]).digest
      return true if new_code.include? chars
    end
    false
  end
end

input = 'jlmsuwbz'
secret_codes = []
i = -1
until secret_codes.size == 64
  i += 1
  new_code = HashCode.new [input, i]
  next unless new_code.valid?
  puts new_code.digest
  secret_codes << new_code.digest
end

puts i
