(load-file "2022.clj/utils.clj")
(ns day9
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(u/dl-input 9)
(def input (map #(str/split % #" ") (u/read-input-lines 9)))

(defn move-tail [[hx hy] [tx ty]]
  (if (>= 1 (max (Math/abs (- hx tx)) (Math/abs (- hy ty))))
    [tx ty]
    (let [dx (u/unit (- hx tx))
          dy (u/unit (- hy ty))]
      [(+ tx dx) (+ ty dy)])))

(defn move-head [[hx hy] dir]
  (case dir
    "U" [hx (+ hy 1)]
    "D" [hx (- hy 1)]
    "L" [(- hx 1) hy]
    "R" [(+ hx 1) hy]))

(defn solve [knots]
  (->> input
       (mapcat (fn [[dir len]] (repeat (parse-long len) dir)))
       (reductions
        (fn [[h & ts] dir]
          (reductions move-tail (move-head h dir) ts)) (repeat knots [0 0]))
       (map last)
       (set)
       (count)))

(map solve [2 10])