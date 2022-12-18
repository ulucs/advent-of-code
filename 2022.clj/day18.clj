(load-file "2022.clj/utils.clj")
(ns day18
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(u/dl-input 18)
(def input (u/read-input-lines 18))

(defn get-dirs [[x y z]]
  [[(inc x) y z] [(dec x) y z] [x (inc y) z] [x (dec y) z] [x y (inc z)] [x y (dec z)]])

(defn get-dirs-limited [[ix iy iz] [sx sy sz] [x y z]]
  (->>
   (get-dirs [x y z])
   (filter #(and (<= ix (first %) sx)
                 (<= iy (second %) sy)
                 (<= iz (last %) sz)))))

(defn fill-outside [ll gd seen loc]
  (let [sides (set (filter (complement ll) (filter (complement seen) (mapcat gd loc))))]
    (if (empty? sides) seen (recur ll gd (into seen sides) sides))))

(def lava-locs
  (->> input
       (map #(str/split % #","))
       (map (partial map parse-long))
       (map vec)
       (set)))

(->> lava-locs
     (mapcat get-dirs)
     (filter (complement lava-locs))
     (count))

(def lmins (map dec (map (partial reduce min) (apply map list lava-locs))))
(def lmaxs (map inc (map (partial reduce max) (apply map list lava-locs))))

(->> (fill-outside lava-locs
                   (partial get-dirs-limited lmins lmaxs)
                   #{lmins} [[0 0 0]])
     (mapcat get-dirs)
     (filter lava-locs)
     (count))
