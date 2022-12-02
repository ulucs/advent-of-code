(ns utils
  (:require [clojure.string :as str]))

(defn read-input-raw [day]
  (-> (str "2022.clj/inputs/" day ".txt")
      (slurp)))

(defn read-input-lines [day]
  (-> (read-input-raw day)
      (str/split #"\n")))