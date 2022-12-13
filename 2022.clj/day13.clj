(load-file "2022.clj/utils.clj")
(ns day13
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(u/dl-input 13)
(def input (u/read-input-raw 13))

(defn compr? [[h1 & t1] [h2 & t2]]
  (cond (and (nil? h1) (nil? h2)) (recur t1 t2)
        (nil? h1) true
        (nil? h2) false
        (and (number? h1) (number? h2)) (if (= h1 h2) (recur t1 t2) (< h1 h2))
        (and (seqable? h1) (not (seqable? h2))) (recur (cons h1 t1) (cons [h2] t2))
        (and (not (seqable? h1)) (seqable? h2)) (recur (cons [h1] t1) (cons h2 t2))
        :else (let [[hh1 & th1] h1 [hh2 & th2] h2]
                (recur (cons hh1 (cons th1 t1)) (cons hh2 (cons th2 t2))))))

(->> input
     (#(str/split % #"\n\n"))
     (map #(str/split % #"\n"))
     (map (partial map load-string))
     (keep-indexed #(when (apply compr? %2) (inc %1)))
     (reduce +))

(def dividers [[[2]] [[6]]])
(->> input
     (#(str/split % #"\n"))
     (map load-string)
     (filter identity)
     (into dividers)
     (sort-by identity compr?)
     (keep-indexed #(when (some (partial = %2) dividers) (inc %1)))
     (reduce *))
