def move_particles(particles)
  particles.map_with_index do |line, index|
    line[3] += line[6]
    line[4] += line[7]
    line[5] += line[8]

    line[0] += line[3]
    line[1] += line[4]
    line[2] += line[5]

    line
  end
end

def part1(particles)
  same = 0
  p_index = 0

  until same == 1000
    particles = move_particles(particles)

    particle = particles.min_by{ |p| p[0].abs + p[1].abs + p[2].abs }
    i = particles.index(particle)
    unless p_index == i
      p_index = i
      same = 0
    end

    same += 1
  end
  puts p_index
end

def part2(particles)
  no_destroy = 0
  particles_count = particles.size

  until no_destroy == 1000
    particles =
      move_particles(particles)
        .group_by { |p| p[0..2]}
        .reduce([] of Array(Int64)) { |acc, x| x[1].size > 1 ? acc : acc << x[1][0] }

    unless particles_count == particles.size
      particles_count = particles.size
      no_destroy = 0
    end

    no_destroy += 1
  end

  puts particles_count
end

input = File.read_lines("day20_input.txt").map { |line| line.gsub(/[a-zA-Z=<>]*/, "").split(",").map(&.to_i64) }

part1(input.clone)
part2(input.clone)
