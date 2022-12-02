(load-file "2022.clj/utils.clj")

(ns day1
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(def input (u/read-input-raw 1))

(def cals (->> (str/split input #"\n\n")
               (map #(str/split % #"\n"))
               (map #(map parse-long %))
               (map #(reduce + %))))

(reduce max cals)
(reduce + (take 3 (sort cals)))

