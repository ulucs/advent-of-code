require 'set'

class Array
  def eliminate!
    del_first = size.odd?
    reject!.each_with_index { |_, i| i.odd? }
    shift if del_first
  end

  def to_delete
    del = Set.new
    ix = 0
    taking = 0
    offs = 0
    odd = size.odd?
    until taking + offs >= size
      taken, ix, taking, odd, offs = del_iter(ix, taking, odd, offs)
      del << taken % size
    end
    del
  end

  def del_iter(ix, taking, odd, offs)
    taken = size / 2 + ix
    ix += odd ? 2 : 1
    taking += 1
    offs += 1 if taken < size
    odd = !odd
    [taken, ix, taking, odd, offs]
  end

  def eliminate2!
    del = to_delete
    reject!.each_with_index { |_, i| del.include? i }
  end

  def eliminate3!
    rotate!(size / 2)
    del = 0
    els = size.odd? ? 1 : 2
    ext = (size % 3).zero? ? 0 : 1
    select!.each_with_index do |_, i|
      next true if del > size * 2/3 - ext
      next true if ((i - els) % 3).zero?
      del += 1
      false
    end
    sort!
  end
end

elves = [*1..3014387]
elves.eliminate3! until elves.size < 2

puts elves.first
