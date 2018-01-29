require 'set'

class Array
  def get_pos(x, y)
    row = self[x] || []
    row[y] || '#'
  end

  def find2(c)
    row = index { |r| r.include? c }
    col = self[row].index(c)
    [row, col]
  end

  def dist(pos)
    x, y = pos
    (first - x).abs + (last - y).abs
  end
end

class Hash
  def rev_get(pos)
    self[pos] || self[pos.reverse] || 0
  end
end

class ASpace < Array
  def insert(_i, v)
    v[:score] = v[:moves]
    insert_before = bsearch_index { |x, _| v[:score] < x[:score] }
    super(insert_before ? insert_before : -1, v)
  end

  def <<(v)
    insert(0, v)
  end
end

class MazeMap
  @@maze = File.read('./24input.txt').split("\n")
  attr_accessor :pos
  attr_reader :dest_pos

  def initialize(first, dest)
    @pos = @@maze.find2(first.to_s)
    @dest_pos = @@maze.find2(dest.to_s)
  end

  def moves
    x, y = @pos
    moveset = []
    [[1, 0], [0, 1], [-1, 0], [0, -1]].each do |dx, dy|
      next if @@maze.get_pos(x + dx, y + dy) == '#'
      nu_mv = dup
      nu_mv.pos = [x + dx, y + dy]
      moveset << nu_mv
    end
    moveset
  end

  def print(moves)
    mc = @@maze.dup
    mc[0] = @@maze.first.dup
    mc.first << moves.to_s
    mc[@pos.first] = @@maze[@pos.first].dup
    mc[@pos.first][@pos.last] = '*'
    puts mc
  end

  def score
    @pos.dist(@dest_pos)
  end
end

distances = {}
[0, 1, 2, 3, 4, 5, 6, 7].combination(2).each do |st, ed|
  search = ASpace.new
  search << ({ map: MazeMap.new(st, ed), moves: 0 })
  prev_pos = Hash.new(1e5)
  distances[[st, ed]] =
    until search.empty?
      lts = search.shift
      lmap = lts[:map]
      lmvs = lts[:moves]
      # lmap.print(lmvs)
      # sleep 0.05
      break lmvs if lmap.pos == lmap.dest_pos
      lmap.moves.each do |nu_map|
        next if prev_pos[nu_map.pos] <= lmvs + 1
        search << ({ map: nu_map, moves: lmvs + 1 })
        prev_pos[nu_map.pos] = lmvs + 1
      end
    end
end
puts distances

z = [1, 2, 3, 4, 5, 6, 7].permutation(7).inject(1e6) do |min_l, its|
  path = '0'
  path_len = 0
  pos = 0
  until its.empty?
    des = its.shift
    path << " -> #{des}"
    path_len += distances.rev_get([pos, des])
    pos = des
  end
  path_len += distances.rev_get([0, pos])
  next min_l if min_l < path_len
  path_len
end
puts z
