(load-file "2022.clj/utils.clj")
(ns day4
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(u/dl-input 4)
(def input (u/read-input-lines 4))

(->> input
     (map #(str/split % #","))
     (map (partial map #(str/split % #"-")))
     (map (partial map (partial map parse-long)))
     (map (partial sort-by (partial apply -)))
     (filter (fn [[[a1 b1] [a2 b2]]] (and (<= a1 a2) (>= b1 b2))))
     (count))

(->> input
     (map #(str/split % #","))
     (map (partial map #(str/split % #"-")))
     (map (partial map (partial map parse-long)))
     (map (partial sort-by first))
     (filter (fn [[[_ b1] [a2 _]]] (>= b1 a2)))
     (count))
