input = File.read('./08input.txt')
ti = 'rect 3x2
rotate column x=1 by 1
rotate row y=0 by 4
rotate column x=1 by 1'

class Screen
  def initialize(x, y)
    @data = Array.new(x).map { Array.new(y).fill(0) }
  end

  def rect(y, x)
    (0...x).each do |xi|
      @data[xi][0...y] = Array.new(y).fill(1)
    end
  end

  def rotaterow(x, r)
    @data[x].rotate!(-r)
  end

  def rotatecol(y, r)
    @data = @data.transpose
    rotaterow(y, r)
    @data = @data.transpose
  end

  def count
    @data.flatten.sum
  end

  def print
    puts(@data.map { |r| r.map { |a| a == 1 ? '#' : ' ' } * '' } * '
')
  end
end

scr = Screen.new(6, 50)
input.each_line do |line|
  x, y = line.scan(/[0-9]+/).map(&:to_i)
  puts line
  case line.slice!(/ \S+/)
  when ' row'
    scr.rotaterow(x, y)
  when ' column'
    scr.rotatecol(x, y)
  else
    scr.rect(x, y)
  end
  scr.print
end

puts scr.count
