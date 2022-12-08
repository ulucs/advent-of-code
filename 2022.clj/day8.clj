(load-file "2022.clj/utils.clj")
(ns day8
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(u/dl-input 8)
(def input (map (comp #(map parse-long %) #(str/split % #"")) (u/read-input-lines 8)))

(defn check-vis [xs] (map > xs (cons -1 (reductions max xs))))
(defn tr [x] (apply (partial map list) x))

(->> [input (map reverse input) (tr input) (map reverse (tr input))]
     (map (partial map check-vis))
     (apply (fn [i mr r rmr] [i (map reverse mr) (tr r) (tr (map reverse rmr))]))
     (map flatten)
     (apply map #(or %1 %2 %3 %4))
     (filter true?)
     (count))

(defn count-vis [[x & xs]]
  (if (empty? xs) [0]
      (cons (min (count xs) (+ 1 (count (take-while (partial > x) xs)))) (count-vis xs))))

(->> [input (map reverse input) (tr input) (map reverse (tr input))]
     (map (partial map count-vis))
     (apply (fn [i mr r rmr] [i (map reverse mr) (tr r) (tr (map reverse rmr))]))
     (map flatten)
     (apply map *)
     (reduce max))
