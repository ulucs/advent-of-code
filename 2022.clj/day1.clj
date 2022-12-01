(ns day1
  (:require [clojure.string :as str]))

(def input (slurp "./inputs/1.txt"))

(def cals (->> (str/split input #"\n\n")
               (map #(str/split % #"\n"))
               (map #(map parse-long %))
               (map #(reduce + %))))

(println (reduce max cals))
(println (reduce + (take 3 (sort cals))))

