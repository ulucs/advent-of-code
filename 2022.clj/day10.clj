(load-file "2022.clj/utils.clj")
(ns day10
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(u/dl-input 10)
(def input (map #(str/split % #" ") (u/read-input-lines 10)))

(defrecord ProgramState [cycle x])

(defn apply-instr [p-states [op arg]]
  (let [state (last p-states)]
    (case op
      "noop" [(assoc state :cycle (inc (:cycle state)))]
      "addx" [(assoc state :cycle (inc (:cycle state)))
              (assoc state :x (+ (:x state) (parse-long arg))
                     :cycle (+ 2 (:cycle state)))])))

(defn draw [{x :x c :cycle}]
  (if (>= 1 (Math/abs (- x (mod (- c 1) 40)))) "#" "."))

(def program-hist (flatten (reductions apply-instr [(ProgramState. 1 1)] input)))

(->> program-hist
     (filter (fn [{c :cycle}] (some #{c} [20 60 100 140 180 220])))
     (map (fn [{c :cycle x :x}] (* c x)))
     (reduce +))

(->> program-hist
     (take 240)
     (map draw)
     (partition 40)
     (map (partial apply str)))
