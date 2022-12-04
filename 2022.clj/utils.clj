(ns utils
  (:require [clojure.string :as str])
  (:require [clojure.java.shell :as shell]))

(defn dl-input [day]
  (shell/sh "bash" "-c"
            (str "curl 'https://adventofcode.com/2022/day/" day "/input' "
                 "-b $(cat ./session.cookie) >"
                 "2022.clj/inputs/" day ".txt")))

(defn read-input-raw [day]
  (-> (str "2022.clj/inputs/" day ".txt")
      (slurp)))

(defn read-input-lines [day]
  (-> (read-input-raw day)
      (str/split #"\n")))

(defn solve [[s g] inp] [(s inp) (g inp)])