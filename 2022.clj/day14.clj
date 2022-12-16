(load-file "2022.clj/utils.clj")
(ns day14
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(u/dl-input 14)
(def input (u/read-input-lines 14))

(defn inc-range [s e]
  (let [d (if (< (u/unit (- e s)) 0) -1 1)]
    (range s (+ e d) d)))

(defn next-steps [[x y]]
  [[x (inc y)] [(dec x) (inc y)] [(inc x) (inc y)]])

(defn place-salt [[x y] cutoff salt-map]
  (if (>= y cutoff) nil
      (let [next (some #(when (not (salt-map %)) %) (next-steps [x y]))]
        (if (nil? next) (conj salt-map [x y])
            (recur next cutoff salt-map)))))

(defn place-salt-w-floor [[x y] floor salt-map]
  (if (= y (dec floor)) (conj salt-map [x y])
      (let [next (some #(when (not (salt-map %)) %) (next-steps [x y]))]
        (if (nil? next)
          (if (zero? y) nil (conj salt-map [x y]))
          (recur next floor salt-map)))))

(def rocks
  (->> input
       (map #(str/split % #" -> "))
       (map (partial map #(str/split % #",")))
       (map (partial map (partial map parse-long)))
       (map (partial partition 2 1))
       (map (partial map (partial apply (partial map list))))
       (mapcat (partial mapcat (fn [[[sx ex] [sy ey]]]
                                 (for [x (inc-range sx ex)
                                       y (inc-range sy ey)] [x y]))))
       (set)))

(->> rocks
     (iterate (partial place-salt [500 0] (inc (reduce max (map second rocks)))))
     (drop 1)
     (take-while identity)
     (count))

(->> rocks
     (iterate (partial place-salt-w-floor [500 0] (+ 2 (reduce max (map second rocks)))))
     (take-while identity)
     (count))