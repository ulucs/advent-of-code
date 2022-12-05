(load-file "2022.clj/utils.clj")
(ns day5
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(u/dl-input 5)
(def input (u/read-input-raw 5))

(def stacks
  (->> (str/split input #"\n\n")
       (first)
       (#(str/split % #"\n"))
       (apply (partial map str))
       (map (partial re-find #"[A-Z]+"))
       (filter #(not (nil? %)))
       (map (partial apply list))
       (vec)))

(def instrs
  (->> (str/split input #"\n\n")
       (second)
       (#(str/split % #"\n"))
       (map #(str/split % #"[^0-9]+"))
       (map rest)
       (map (partial map parse-long))))

(defn move [multi? towers [no from to]]
  (assoc towers
         (- from 1) (drop no (nth towers (- from 1)))
         (- to 1) (concat
                   ((if multi? identity reverse) (take no (nth towers (- from 1))))
                   (nth towers (- to 1)))))

(->> [(partial move false) (partial move true)]
     (map #(reduce % stacks instrs))
     (map (partial map first))
     (map (partial str/join "")))