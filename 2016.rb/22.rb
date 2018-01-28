require 'set'
input = File.read('./22input.txt')

class DevNode
  attr_reader :used, :pos, :size
  def initialize(x, y, sz, usd)
    @pos = [x.to_i, y.to_i]
    @size = sz.to_i
    @used = usd.to_i
  end

  def available
    size - used
  end

  def usage?
    used != 0
  end
end

class ASpace < Array
  def insert(_i, v)
    v[:score] = v[:map].score
    insert_before = bsearch_index { |x, _| v[:score] < x[:score] }
    super(insert_before ? insert_before : -1, v)
  end

  def <<(v)
    insert(0, v)
  end
end

class NodeMap
  attr_accessor :data_pos

  def str_rep(x, y)
    return 'G' if @data_pos == [x, y]
    tot = @used[[x, y]]
    return '_' if tot.zero?
    return '#' if tot >= 100
    '.'
  end

  def print
    (0..31).map do |x|
      (0..30).map do |y|
        str_rep(x, y)
      end.join('')
    end.join("\n")
  end

  def absorb_its(node_list)
    @data_pos = [31, 0]
    @used = {}
    @tots = {}
    node_list.each do |node|
      @used[node.pos] = node.used
      @tots[node.pos] = node.size
    end
  end

  def move(pos_fr, pos_to)
    @used = @used.dup
    size = @used[pos_fr]
    @used[pos_fr] -= size
    @used[pos_to] += size
  end

  def move_valid?(pos_fr, pos_to)
    return false if @used[pos_to].nil?
    @used[pos_fr] + @used[pos_to] <= @tots[pos_to]
  end

  def avl_moves(pos)
    x, y = pos
    moveset = []
    [[1, 0], [0, 1], [-1, 0], [0, -1]].each do |dx, dy|
      pos_to = [x + dx, y + dy]
      next unless move_valid?(pos, pos_to)
      # puts "#{pos * ','} -> #{pos_to * ','}"
      nu_map = dup
      nu_map.move(pos, pos_to)
      # puts nu_map.print
      nu_map.data_pos = pos_to if data_pos == pos
      moveset << nu_map
    end
    moveset
  end

  def each_pos
    @used.each_key
  end

  def score
    x, y = @data_pos
    zx, zy = @used.key(0)
    zero_sc = (x - 1 - zx).abs + (y - zy).abs
    x + y + 0.01 * zero_sc
  end
end

node_list = input.lines.map do |line|
  x, y, sz, usd = line.scan(/[0-9]+/).map(&:to_i)
  DevNode.new(x, y, sz, usd)
end

puts(node_list.combination(2).inject(0) do |sum, (n1, n2)|
  sum += 1 if n1.usage? &&
    n1.used <= n2.available
  sum += 1 if n2.usage? &&
    n2.used <= n1.available
  sum
end)

a_sp = ASpace.new
init_map = NodeMap.new
prev_pos = Set.new
init_map.absorb_its(node_list)
a_sp << ({ map: init_map, moves: 0 })

until a_sp.empty?
  evalt = a_sp.shift
  map = evalt[:map]
  moves = evalt[:moves]
  av_moves = map.each_pos.map { |pos| map.avl_moves(pos) }.flatten
  av_moves.each do |moved_m|
    a_sp << ({ map: moved_m, moves: moves + 1 }) unless prev_pos.include? moved_m.print
    prev_pos << moved_m.print
    next unless moved_m.data_pos == [0, 0]
    puts moves + 1
    exit
  end
end
