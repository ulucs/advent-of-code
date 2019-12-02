require 'set'
dir_dict = { 'R' => { 'u' => 'r', 'r' => 'd', 'd' => 'l', 'l' => 'u' },
             'L' => { 'u' => 'l', 'l' => 'd', 'd' => 'r', 'r' => 'u' } }
direction = 'u'
x = 0
y = 0
found = false
visited_locations = Set.new [[0, 0]]
# rubocop:disable Metrics/LineLength
input = 'L1, L3, L5, L3, R1, L4, L5, R1, R3, L5, R1, L3, L2, L3, R2, R2, L3, L3, R1, L2, R1, L3, L2, R4, R2, L5, R4, L5, R4, L2, R3, L2, R4, R1, L5, L4, R1, L2, R3, R1, R2, L4, R1, L2, R3, L2, L3, R5, L192, R4, L5, R4, L1, R4, L4, R2, L5, R45, L2, L5, R4, R5, L3, R5, R77, R2, R5, L5, R1, R4, L4, L4, R2, L4, L1, R191, R1, L1, L2, L2, L4, L3, R1, L3, R1, R5, R3, L1, L4, L2, L3, L1, L1, R5, L4, R1, L3, R1, L2, R1, R4, R5, L4, L2, R4, R5, L1, L2, R3, L4, R2, R2, R3, L2, L3, L5, R3, R1, L4, L3, R4, R2, R2, R2, R1, L4, R4, R1, R2, R1, L2, L2, R4, L1, L2, R3, L3, L5, L4, R4, L3, L1, L5, L3, L5, R5, L5, L4, L2, R1, L2, L4, L2, L4, L1, R4, R4, R5, R1, L4, R2, L4, L2, L4, R2, L4, L1, L2, R1, R4, R3, R2, R2, R5, L1, L2'.split(', ')
# rubocop:enable Metrics/LineLength

def make_range(ox, x)
  if x == ox then ox..x
  else
    x > ox ? (ox + 1)..x : x...ox
  end
end

input.each do |item|
  dir = item.slice!(0)
  direction = dir_dict[dir][direction]
  ox = x
  oy = y
  case direction
  when 'u'
    y += item.to_i
  when 'd'
    y -= item.to_i
  when 'r'
    x += item.to_i
  when 'l'
    x -= item.to_i
  end

  next if found
  rangex = make_range(ox, x)
  rangey = make_range(oy, y)
  [*rangex].product([*rangey]).each do |rx, ry|
    if visited_locations.include?([rx, ry])
      puts rx.abs + ry.abs
      found = true
    end
    visited_locations.add([rx, ry])
  end
end

puts x.abs + y.abs
