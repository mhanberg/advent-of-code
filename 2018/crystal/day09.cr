player_scores = {} of Int32 => UInt64
(1..458).each { |p| player_scores[p] = 0_u64 }
marbles = Deque.new([0_u64])
current_marble = 1_u64

(1..458)
  .cycle()
  .first(72019 * 100)
  .each do |player|
    if current_marble % 23 == 0
      marbles.rotate!(7)
      removed_marble = marbles.shift
      
      player_scores[player] += (current_marble + removed_marble)

      marbles.rotate!(-1)
      current_marble += 1
    else
      marbles.rotate!(-1)
      marbles.unshift(current_marble)
      current_marble += 1
    end
  end

p player_scores.max_by { |p, s| s }
