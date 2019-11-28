(ns clojure-of-code.day-01)

(defn part-1
  [x]
  (->> (clojure.string/split-lines x)
       (map (fn [i] (Integer/parseInt i)))
       (reduce + 0)))

(defn repeated-frequency
  ([fl]
   (repeated-frequency #{} 0 fl fl))

  ([freqs, freq, l, fl]
  (let [li (if (empty? l) fl l)]
    (if (contains? freqs freq)
      freq
      (recur (conj freqs freq) (+ (first li) freq) (rest li) fl)))))

(defn part-2
  [x]
  (->> (clojure.string/split-lines x)
       (map (fn [i] (Integer/parseInt i)))
       (repeated-frequency)))
