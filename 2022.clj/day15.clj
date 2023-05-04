(load-file "2022.clj/utils.clj")
(ns day15
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(u/dl-input 15)
(def input (u/read-input-lines 15))

(def input (str/split "Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3" #"\n"))

(defn get-area-slice [row [[y x] r]]
  (let [len (- r (Math/abs (- row x)))]
    (if (>= len 0) [(- y len) (+ y len)] nil)))

(defn merge-ranges [[r1 r2 & rs]]
  (if (nil? r2) (list r1)
      (let [[s1 e1] r1
            [s2 e2] r2]
        (if (>= e1 s2)
          (merge-ranges (cons [s1 (Math/max e1 e2)] rs))
          (cons r1 (merge-ranges (cons r2 rs)))))))

(def beacon-data
  (->> input
       (map (partial re-seq #"[0-9]+"))
       (map (partial map parse-long))
       (map (partial partition 2))
       (map (fn [[[x1 y1] [x2 y2]]]
              [[x1 y1] (+ (Math/abs (- x1 x2))
                          (Math/abs (- y1 y2)))]))))

(->> beacon-data
     (keep (partial get-area-slice 2000000))
     (sort-by first)
     (merge-ranges)
     (map #(inc (- (second %) (first %))))
     (reduce +)
     (dec))

