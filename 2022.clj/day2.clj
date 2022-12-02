(load-file "2022.clj/utils.clj")

(ns day2
  (:require [utils :as u]))

(def input (u/read-input-lines 2))

(defn eval-game [ips]
  (case ips
    "A X" [1 1] ; rock
    "B X" [0 1] ; paper
    "C X" [2 1] ; scissors
    "A Y" [2 2]
    "B Y" [1 2]
    "C Y" [0 2]
    "A Z" [0 3]
    "B Z" [2 3]
    "C Z" [1 3]))

(defn eval-game2 [ips]
  (case ips
    "A X" [0 3] ; lose
    "A Y" [1 1] ; draw
    "A Z" [2 2] ; win
    "B X" [0 1]
    "B Y" [1 2]
    "B Z" [2 3]
    "C X" [0 2]
    "C Y" [1 3]
    "C Z" [2 1]))

(->>  [eval-game eval-game2]
      (map (fn [eg] (->> input
                         (map eg)
                         (map #(+ (* 3 (first %)) (second %)))
                         (reduce +)))))