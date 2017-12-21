input = File.read_lines("day20_input.txt").map { |line| line.gsub(/[a-zA-Z=<>]*/, "").split(",").map(&.to_i64) }

same = 0
p_index = 0

until same == 100000
  input.map_with_index! do |line, index|
    line[3] += line[6]
    line[4] += line[7]
    line[5] += line[8]

    line[0] += line[3]
    line[1] += line[4]
    line[2] += line[5]

    line
  end

  particle = input.min_by{ |p| p[0].abs + p[1].abs + p[2].abs }
  i = input.index(particle)
  unless p_index == i
    p_index = i
    same = 0
  end

  same += 1
end

puts p_index
