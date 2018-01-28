inputs = File.read('./21input.txt')

testInp = 'swap position 4 with position 0
swap letter d with letter b
reverse positions 0 through 4
rotate left 1 step
move position 1 to position 4
move position 3 to position 0
rotate based on position of letter b
rotate based on position of letter d'

rot_bs = 'rotate based on position of letter a
rotate based on position of letter b
rotate based on position of letter c
rotate based on position of letter d
rotate based on position of letter e
rotate based on position of letter f
rotate based on position of letter g
rotate based on position of letter h'

class String
  def swap_pos!(x, y)
    x = x.to_i
    y = y.to_i
    tmp = self[x]
    self[x] = self[y]
    self[y] = tmp
  end

  def swap_let!(x, y)
    tr!(x, '*')
    tr!(y, x)
    tr!('*', y)
  end

  def rotate(x)
    split('').rotate(x.to_i).join('')
  end

  def rot_r(x)
    rotate(-x.to_i)
  end

  def rot_l(x)
    rotate(x.to_i)
  end

  def rot_b(x)
    rot_len = 1 + index(x) + (index(x) >= 4 ? 1 : 0)
    rotate(-rot_len)
  end

  def rot_b_rev(x)
    ix = index(x)
    return rotate((ix + 1) / 2) if ix.odd?
    rotate(-
      case ix
      when 0
        -1
      when 2
        2
      when 4
        1
      when 6
        0
      end)
  end

  def rev!(x, y)
    ran = x.to_i..y.to_i
    self[ran] = self[ran].reverse
  end

  def mov!(x, y)
    l = self[x.to_i]
    self[x.to_i] = ''
    insert(y.to_i, l)
  end
end

pass = 'abcdefgh'

inputs.each_line do |inp|
  x, y = inp.scan(/\b\S\b/)
  case inp
  when /^swap p/
    pass.swap_pos!(x, y)
  when /^swap l/
    pass.swap_let!(x, y)
  when /^rotate l/
    pass = pass.rot_l(x)
  when /^rotate r/
    pass = pass.rot_r(x)
  when /^rotate b/
    pass = pass.rot_b(x)
  when /^rev/
    pass.rev!(x, y)
  when /^mov/
    pass.mov!(x, y)
  end
end

tryrev = 'fbgdceah'
inputs.lines.reverse_each do |inp|
  x, y = inp.scan(/\b\S\b/)
  case inp
  when /^swap p/
    tryrev.swap_pos!(x, y)
  when /^swap l/
    tryrev.swap_let!(x, y)
  when /^rotate l/
    tryrev = tryrev.rot_r(x)
  when /^rotate r/
    tryrev = tryrev.rot_l(x)
  when /^rotate b/
    tryrev = tryrev.rot_b_rev(x)
  when /^rev/
    tryrev.rev!(x, y)
  when /^mov/
    tryrev.mov!(y, x)
  end
end
puts tryrev
