(ns advent-of-code.day-01)

(defn fuel [mass] (- (quot mass 3) 2))

(defn part-1
  "Day 01 Part 1"
  [masses]
  (->>
    (map fuel masses)
    (reduce + 0)))

(defn calculate-max-fuel
  [fuels mass]
  (let [fuel (fuel mass)]
    (if (<= fuel 0)
      fuels
      (recur (+ fuels fuel) fuel))))

(defn part-2
  "Day 01 Part 2"
  [masses]
  (->>
    (map (fn [mass] (calculate-max-fuel 0 mass)) masses)
    (reduce + 0)))
