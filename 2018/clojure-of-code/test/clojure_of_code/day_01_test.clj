(ns clojure-of-code.day-01-test
  (:require [clojure.test :refer :all]
            [clojure-of-code.day-01 :refer :all]))

(clojure.test/deftest part1
  (testing "part 1"
    (is (= 516 (clojure-of-code.day-01/part-1 (slurp "../../2018/priv/day01/input.txt"))))))

(clojure.test/deftest part2
  (testing "part 2"
    (is (= 71892 (clojure-of-code.day-01/part-2 (slurp "../../2018/priv/day01/input.txt"))))))
