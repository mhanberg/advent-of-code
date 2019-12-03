(ns advent-of-code.day-02)

(defn adjust-codes
  [opcode-map pos adjuster]
  (let [x1 (opcode-map (+ pos 1)) x2 (opcode-map (+ pos 2))]
    (assoc opcode-map
           (opcode-map (+ pos 3))
           (apply adjuster [(opcode-map x1) (opcode-map x2)])
           )))

(defn traverse-codes
  [pos opcode-map]
  (case (opcode-map pos)
    1 (recur (+ pos 4) (adjust-codes opcode-map pos +))
    2 (recur (+ pos 4) (adjust-codes opcode-map pos *))
    99 opcode-map))

(defn parse-input
  [input]
    (->> (map-indexed list input)
         (reduce (fn [opcode-map kv]
                   (assoc opcode-map (first kv) (last kv))) {})))

(defn part-1
  "Day 02 Part 1"
  [input]
  (def opcodes
    (->> (parse-input input)
         (traverse-codes 0)))
  (get opcodes 0))

(defn merge-noun-verb
  [noun verb opcode-map]
  (merge opcode-map {1 noun 2 verb}))

(defn compute-answer
  [output]
  (+ (* 100 (nth output 1)) (nth output 2)))

(defn part-2
  "Day 02 Part 2"
  [input]
  (->>
    (for [noun (range 100) verb (range 100)]
      (let [opcodes (->>
                      (parse-input input)
                      (merge-noun-verb noun verb)
                      (traverse-codes 0))]
        [(get opcodes 0) noun verb]))
    (filter (fn [output]
              (== (first output) 19690720)))
    (first)
    (compute-answer)))
