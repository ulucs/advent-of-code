(load-file "2022.clj/utils.clj")
(ns day12
  (:require [utils :as u]))

(u/dl-input 12)
(def input (u/read-input-lines 12))

(defn low-points [m] (map first (filter (comp (partial = \a) second) m)))
(defn start-of [m] (first (first (filter (comp (partial = \S) second) m))))
(def end-of (memoize (fn [m] (first (first (filter (comp (partial = \E) second) m))))))
(defn elevation [m]
  (case m
    \E (int \z)
    \S (int \a)
    (int m)))

(defn valid-moves [m [x y]]
  (->> [[(inc x) y] [(dec x) y] [x (inc y)] [x (dec y)]]
       (filter (fn [[nx ny]] (contains? m [nx ny])))
       (filter (fn [[nx ny]] (>= (inc (elevation (get m [x y]))) (elevation (get m [nx ny])))))))

(defn find-path [m seen [[cxy & _ :as path] & nexts]]
  (if (= cxy (end-of m)) path
      (let [next-moves (filter #(not (contains? seen %)) (valid-moves m cxy))]
        (recur m (into seen next-moves)
               (->> next-moves
                    (map #(conj path %))
                    (into (vec nexts)))))))

(->> input
     (map (partial map char))
     (map-indexed (fn [y row] (map-indexed (fn [x c] {[x y] c}) row)))
     (flatten)
     (reduce conj)
     (#(find-path %  #{(start-of %)} [(list (start-of %))]))
     (count)
     (dec))

(->> input
     (map (partial map char))
     (map-indexed (fn [y row] (map-indexed (fn [x c] {[x y] c}) row)))
     (flatten)
     (reduce conj)
     (#(find-path % (set (low-points %)) (vec (map list (low-points %)))))
     (count)
     (dec))
