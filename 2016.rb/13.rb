require 'set'

class Array
  def dist(b)
    a, s = self
    q, w = b
    (a - q).abs + (s - w).abs
  end

  def valid?
    x, y = self
    return false if x < 0 || y < 0
    val = (x + y)**2 + (3 * x) + y + 1352
    val.to_s(2).split('').count('1').even?
  end
end

class ASpace < Array
  def insert(_i, v)
    v[:score] = - v[:items].dist([31, 39])
    insert_before = bsearch_index { |x, _| v[:score] > x[:score] }
    super(insert_before ? insert_before : -1, v)
  end

  def <<(v)
    insert(0, v)
  end

  alias push <<
  alias unshift <<
end

frontier = ASpace.new [{ score: 0, items: [1, 1], steps: 0 }]
old_els = Set.new [[1, 1]]

until frontier.empty?
  st = frontier.shift
  x, y = st[:items]
  sts = st[:steps]
  [[1, 0], [0, 1], [-1, 0], [0, -1]].each do |dx, dy|
    new_its = [x + dx, y + dy]
    next if old_els.include? new_its

    new_state = { items: new_its, steps: sts + 1 }
    old_els.add new_its
    frontier << new_state if new_its.valid?

    next unless new_its == [31, 39]
    puts new_state
    break
  end
end

frontier2 = [{ items: [1, 1], steps: 0 }]
expand = Set.new [[1, 1]]

until frontier2.empty?
  st = frontier2.shift
  x, y = st[:items]
  sts = st[:steps]
  [[1, 0], [0, 1], [-1, 0], [0, -1]].each do |dx, dy|
    new_its = [x + dx, y + dy]
    next if expand.include?(new_its) || sts >= 50 || !new_its.valid?

    new_state = { items: new_its, steps: sts + 1 }
    expand.add new_its
    frontier2 << new_state if new_its.valid?
  end
end

puts expand.size
