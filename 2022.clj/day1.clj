(ns day1
  (:require [clojure.string :as str]))

(def input (slurp "2022.clj/inputs/1.txt"))

(def cals (->> (str/split input #"\n\n")
               (map #(str/split % #"\n"))
               (map #(map parse-long %))
               (map #(reduce + %))))

(reduce max cals)
(reduce + (take 3 (sort cals)))

