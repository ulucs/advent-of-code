positions = []
locs = [[17, 1], [7, 0], [19, 2], [5, 0], [3, 0], [13, 5], [11 ,0]]
# locs = [[5, 4], [2, 1]]

locs.each do |l, p|
  nu_arr = Array.new l, 0
  nu_arr[p] = 1
  positions << nu_arr
end

class Array
  def bounce?(i)
    self[-i % size] != 1
  end
end

(0..Float::INFINITY).each do |t|
  # puts ''
  next if positions.each_with_index.inject(false) do |rb, (pos, i)|
    # r = pos.map(&:to_s)
    # r[-(i + t + 1) % pos.size] = format('[%s]', r[-(i + t + 1) % pos.size])
    # puts r * ','
    rb || pos.bounce?(i + t + 1)
  end
  puts t
  break
end
