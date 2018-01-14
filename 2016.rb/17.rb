require 'digest'

class String
  def open_doors
    open = []
    dirs = 'UDLR'
    (self[0...4]).chars.each_with_index do |c, i|
      open << dirs[i] if ('b'..'f').cover? c
    end
    open
  end

  def code
    Digest::MD5.hexdigest('udskfozm' + self)
  end
end

class Array
  def dist(b)
    a, s = self
    q, w = b
    (a - q).abs + (s - w).abs
  end

  def il_dirs
    x, y = self
    dirs = []
    dirs << 'U' if x == 0
    dirs << 'D' if x == 3
    dirs << 'L' if y == 0
    dirs << 'R' if y == 3
    dirs
  end
end

class ASpace < Array
  def insert(_i, v)
    v[:score] = - v[:items].dist([3, 3])
    insert_before = bsearch_index { |x, _| v[:score] > x[:score] }
    super(insert_before ? insert_before : -1, v)
  end

  def <<(v)
    insert(0, v)
  end

  alias push <<
  alias unshift <<
end

moves = { 'U' => [-1, 0], 'D' => [1, 0], 'L' => [0, -1], 'R' => [0, 1] }
a_spc = ASpace.new
a_spc << ({ items: [0, 0], path: '' })

max_len = 0
until a_spc.empty?
  st = a_spc.shift
  plc = st[:items]
  pth = st[:path]

  open = pth.code.open_doors
  illegal = plc.il_dirs
  x, y = plc 

  (open - illegal).each do |dir|
    dx, dy = moves[dir]
    new_plc = [x + dx, y + dy]
    new_pth = pth + dir

    a_spc << ({ items: new_plc, path: new_pth }) unless new_plc == [3, 3]
    next unless new_plc == [3, 3] && new_pth.length > max_len

    puts "#{new_pth.length} (#{a_spc.length})"
    max_len = new_pth.length
  end
end
