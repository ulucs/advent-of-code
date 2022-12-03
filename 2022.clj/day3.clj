(load-file "2022.clj/utils.clj")

(ns day3
  (:require [utils :as u])
  (:require [clojure.string :as str])
  (:require [clojure.set :as set]))

(u/dl-input 3)

(def input (u/read-input-lines 3))
(def ti (str/split "vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
" #"\n"))

(map int (char-array "azAZ"))

(defn priority [c]
  (case (<= 97 c 122)
    true (- c 96)
    false (+ 27 (- c 65))))

(->> input
     (map (fn [line]
            (->>
             (char-array line)
             (map int)
             (map priority)
             (#(split-at (quot (count %) 2) %))
             (map set)
             (apply set/intersection)
             (seq))))
     (flatten)
     (reduce +))

(->> input
     (map (fn [line]
            (->>
             (char-array line)
             (map int)
             (map priority))))
     (partition 3)
     (map (fn [part]
            (->> part
                 (map set)
                 (apply set/intersection)
                 (seq))))
     (flatten)
     (reduce +))