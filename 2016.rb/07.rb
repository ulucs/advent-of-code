input = File.read('./07input.txt')

class String
  def inner
    scan(/\[.*?\]/).join('')
  end

  def outer
    scan(/(?:^|\]).*?(?:$|\[)/).join('')
  end

  def abba?
    !scan(/(.)(.)\2\1/).reject { |a, b| a == b }.empty?
  end

  def aba
    scan(/(.)(?=.\1)/)
      .uniq
      .flat_map { |a| scan(/(#{a})(.)(?=#{a})/) }
      .reject { |a, b| a == b }
  end

  def ssl?
    ia = inner.aba
    ob = outer.aba.map(&:reverse)
    ia.any? { |a| ob.include? a }
  end
end

z = input.lines
         .reject { |line| line.inner.abba? }
         .select { |line| line.outer.abba? }
puts z.length

z2 = input.lines
          .select(&:ssl?)
puts z2.length
