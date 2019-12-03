(ns advent-of-code.utils
  (:require [clojure.java.io :refer [resource]]))

(defn string-to-int-list
  [string]
  (->>
    (clojure.string/split-lines string)
    (map (fn [x] (Integer/parseInt x)))))

(defn comma-int-list
  [string]
  (->>
    (clojure.string/split string #",")
    (map (fn [x] (Integer/parseInt (clojure.string/trim x))))))

(defn resource-to-int-list
  [file]
  (->>
    (resource file)
    (slurp)
    (string-to-int-list)))

(defn resource-to-int-list-commas
  [file]
  (->>
    (resource file)
    (slurp)
    (comma-int-list)))
