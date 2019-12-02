require 'set'

test = [
  ['H-M', 'Li-M'],
  ['H-G'],
  ['Li-G'],
  []
]
input = [
  ['Pr-G', 'Pr-M'],
  ['Co-G', 'Cu-G', 'Rt-G', 'Pl-G'],
  ['Co-M', 'Cu-M', 'Rt-M', 'Pl-M'],
  []
]
input_2 = [
  ['Pr-G', 'Pr-M', '1-M', '1-G', '2-M', '2-G'],
  ['Co-G', 'Cu-G', 'Rt-G', 'Pl-G'],
  ['Co-M', 'Cu-M', 'Rt-M', 'Pl-M'],
  []
]

class ASpace < Array
  def insert(_i, v)
    v[:score] = v[:items].score / v[:steps]
    insert_before = bsearch_index { |x, _| v[:score] > x[:score] }
    super(insert_before ? insert_before : -1, v)
  end

  def <<(v)
    insert(0, v)
  end

  alias push <<
  alias unshift <<
end

class Array
  def valid?
    gens = []
    chips = []
    each do |item|
      t, s = item.split '-'
      gens.push(t) if s == 'G'
      chips.push(t) if s == 'M'
    end
    gens.empty? || chips.all? { |ct| gens.include? ct }
  end

  def serialize(flr_no)
    ser = flr_no.to_s
    counts = []
    each do |its|
      ser << ';'
      its.sort.each do |item|
        t, s = item.split '-'
        counts << t unless counts.index t
        ser << '%i%s' % [counts.index(t), s]
      end
    end
    ser
  end

  def score
    each_with_index.inject(0) do |total, (its, index)|
      total + (its.length * index**14)
    end
  end
end

depth = ASpace.new [{ el: 0, items: input_2, steps: 0, score: 0 }]
old_sts = Set.new

until depth.empty?
  it = depth.shift
  flr_n = it[:el]
  items = it[:items]
  steps = it[:steps]
  [[1, -1], [1, 1], [2, -1], [2, 1]].each do |i, j|
    next unless (0...(items.size)).cover?(flr_n + j)
    items[flr_n].combination(i) do |its|
      new_items = items[0..-1]
      new_items[flr_n] -= its
      new_items[flr_n + j] += its
      new_state = { el: flr_n + j, items: new_items, steps: steps + 1 }
      new_el = new_items.serialize(flr_n + j)

      next unless new_items.all?(&:valid?) && !old_sts.include?(new_el)
      depth << new_state
      old_sts.add new_el

      next unless new_items[3].length == 14
      puts new_state
      exit
    end
  end
end
