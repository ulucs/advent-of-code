(load-file "2022.clj/utils.clj")
(ns day6
  (:require [utils :as u]))

(u/dl-input 6)
(def input (u/read-input-raw 6))

(defn windowed [n coll]
  (->> coll
       (repeat n)
       (map-indexed (fn [i l] (drop i l)))
       (apply map list)))

(defn solve [n]
  (->> (apply list input)
       (windowed n)
       (map (comp count set))
       (keep-indexed #(when (= n %2) (+ n %1)))
       (first)))

(map solve [4 14])