(load-file "2022.clj/utils.clj")
(ns day7
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(u/dl-input 7)
(def input (u/read-input-lines 7))

(defrecord ParserState [items currentDir])

(defn cd [current next]
  (-> (str current "/" next)
      (str/replace #"/[a-z]+/+\.\." "")))

(defn gp [path] (cons "/" (filter not-empty (str/split path #"/"))))

(defn parseCommand [line state]
  (if (str/starts-with? line "$ cd")
    (let [[_ _ dir] (str/split line #" ")]
      (assoc state :currentDir (cd (get state :currentDir) dir)))
    state))

(defn parseItem [line state]
  (let [[sd name] (str/split line #" ")]
    (assoc-in state (concat [:items] (gp (get state :currentDir)) [name]) (parse-long sd))))

(defn parse [state line]
  (if (str/starts-with? line "$")
    (parseCommand line state)
    (parseItem line state)))

(defn sizeOf [items]
  (->> (map (fn [[_ v]] (if (map? v) (sizeOf v) v)) items)
       (reduce +)))

(defn rec-size [input]
  (if (map? input)
    (cons (sizeOf input) (map rec-size (vals input))) 0))

(def fs (get-in (reduce parse (ParserState. {} "/") input) [:items]))

(->> (rec-size fs)
     (flatten)
     (filter (partial >= 100000))
     (reduce +))

(->> (rec-size fs)
     (flatten)
     (filter #(>= 40000000 (- (sizeOf fs) %)))
     (reduce min))

