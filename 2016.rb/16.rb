class Integer
  def max_bit
    (2**bit_length) - 1
  end

  def reverse
    # so much faster than our old integer stuff
    to_s(2).reverse.to_i(2)
  end

  def b
    max_bit ^ reverse
  end

  def iter
    self * 2**(bit_length + 1) + b
  end
end

class String
  def eq_n?(n)
    self[2 * n] == self[2 * n + 1]
  end

  def checksum_it
    s = ''
    (0...size / 2).each do |n|
      s << (eq_n?(n) ? '1' : '0')
    end
    s
  end

  def checksum
    s = self
    s = s.checksum_it until s.size.odd?
    s
  end
end

a = '11101000110010100'.to_i 2
a = a.iter until a.bit_length >= 35_651_584
puts a.to_s(2)[0...35_651_584].checksum
