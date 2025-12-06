class Day_5
  attr_reader :ranges
  attr_reader :ingredients

  def initialize
    input = File.read("data/5.txt")
    r, i = input.split(/\n\n/)

    @ranges = r.split(/\n/).map do |line|
      s, e = line.split(/-/).map(&:to_i)

      Range.new(s, e)
    end.sort_by(&:begin)

    @ingredients = i.split(/\n/).map(&:to_i)
  end

  def part_1
    ingredients.count { |i| ranges.any? { |r| r.include? i } }
  end

  def merge_ranges
    rs = ranges.dup
    merged = []
    while rs.length > 0
      r = rs.shift
      while rs.first && r.overlap?(rs.first)
        b = [r.begin, rs.first.begin].min
        e = [r.end, rs.first.end].max
        r = (b..e)
        rs.shift
      end
      merged << r
    end

    @ranges = merged
  end

  def part_2
    merge_ranges
    ranges.sum(&:size)
  end
end
