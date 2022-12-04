(load-file "2022.clj/utils.clj")

(ns day4
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(u/dl-input 4)

(def input (u/read-input-lines 4))

(->> input
     (map #(str/split % #","))
     (map (fn [x] (map #(str/split % #"-") x)))
     (map (fn [x] (map (fn [y] (map parse-double y)) x)))
     (map (fn [x] (sort-by (fn [[a b]] (- a b)) x)))
     (filter (fn [[[a1 b1] [a2 b2]]] (or (<= a1 a2) (>= b1 b2))))
     (count))

(->> input
     (map #(str/split % #","))
     (map (fn [x] (map #(str/split % #"-") x)))
     (map (fn [x] (map (fn [y] (map parse-double y)) x)))
     (map (fn [x] (sort-by (fn [[a]] a) x)))
     (filter (fn [[[_ b1] [a2 _]]] (>= b1 a2)))
     (count))

