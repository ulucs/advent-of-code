(load-file "2022.clj/utils.clj")
(ns day19
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(u/dl-input 19)
(def input (u/read-input-lines 19))


(defrecord Blueprint [ore-r-c clay-r-c obs-r-c geo-r-c])
(defrecord )

(->> input
     (map (partial re-seq #"[0-9]+"))
     (map (partial drop 1))
     (map (partial map parse-long))
     (map (fn [[a b c d e f]]
            (Blueprint. [a 0 0 0] [b 0 0 0] [c d 0 0] [e 0 f 0]))))