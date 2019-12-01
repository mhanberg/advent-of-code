(ns advent-of-code.day-01-test
  (:require [clojure.test :refer [deftest testing is]]
            [advent-of-code.day-01 :refer [part-1 part-2]]
            [advent-of-code.utils :as utils]))

(deftest part1
  (let [expected (+ 2 2 654 33583)]
    (is (= expected (part-1 (utils/resource-to-int-list "day-01-example.txt"))))))

(deftest part2
  (let [expected nil]
    (is (= expected (part-2 (utils/resource-to-int-list "day-01-example.txt"))))))
