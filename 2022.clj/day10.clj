(load-file "2022.clj/utils.clj")
(ns day10
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(u/dl-input 10)
(def input (map #(str/split % #" ") (u/read-input-lines 10)))

(defrecord ProgramState [cycle x])
(defn asof [hist c] (assoc (last (take-while #(<= (:cycle %) c) hist)) :cycle c))

(defn apply-instr [state [op arg]]
  (case op
    "noop" (assoc state :cycle (inc (:cycle state)))
    "addx" (assoc state :x (+ (:x state) (parse-long arg))
                  :cycle (+ 2 (:cycle state)))))

(defn draw [state]
  (if (>= 1 (Math/abs (- (:x state) (mod (- (:cycle state) 1) 40)))) "#" "."))

(def program-hist (reductions apply-instr (ProgramState. 1 1) input))

(->> (range 20 221 40)
     (map (partial asof program-hist))
     (map #(* (:x %) (:cycle %)))
     (reduce +))

(->> (range 1 241)
     (map (partial asof program-hist))
     (map draw)
     (partition 40)
     (map (partial apply str)))
