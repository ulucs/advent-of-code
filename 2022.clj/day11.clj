(load-file "2022.clj/utils.clj")
(ns day11
  (:require [utils :as u])
  (:require [clojure.string :as str]))

(u/dl-input 11)
(defrecord Monke [items op test-div target-t target-f])
(defrecord Game [monke-turn cycle divisor monke-map])

(def input (u/read-input-raw 11))
(def ti "Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1")

(defn find-divisor [monkes]
  (->> monkes
       (map (comp :test-div second))
       (reduce *)))

(def i-game-state
  (->> (str/split input #"\n\n")
       (map #(str/split % #"\n"))
       (map (fn [[nm its op test if else]]
              {(parse-long (re-find #"\d+" nm))
               (Monke.
                (map parse-long (re-seq #"[0-9]+" its))
                (str/split (last (str/split op #"= ")) #" ")
                (parse-long (re-find #"\d+" test))
                (parse-long (re-find #"\d+" if))
                (parse-long (re-find #"\d+" else)))}))
       (reduce merge)
       (#(Game. 0 0 (find-divisor %) %))))

(defn find-target-wl
  [{[throw & _] :items [a f b] :op td :test-div tt :target-t tf :target-f}]
  (let [wl (quot
            (let [a (if (= a "old") throw (parse-long a))
                  b (if (= b "old") throw (parse-long b))]
              (if (= f "+") (+ a b) (* a b))) 1)]
    [(if (= 0 (mod wl td)) tt tf) wl]))

(defn game-step [{mt :monke-turn cy :cycle mm :monke-map dv :divisor}]
  (let [monke (mm mt)]
    (if (empty? (:items monke))
      (Game. (mod (inc mt) (count mm)) (+ cy (quot (inc mt) (count mm))) dv mm)
      (Game.
       mt cy dv
       (let [[target item] (find-target-wl monke)
             t-monke (get mm target)]
         (assoc mm
                mt (assoc monke :items (rest (:items monke)))
                target (assoc t-monke :items (cons (mod item dv) (:items t-monke)))))))))

(defn inspecting? [{mt :monke-turn mm :monke-map}]
  (seq (:items (mm mt))))

(->> (iterate game-step i-game-state)
     (filter inspecting?)
     (take-while #(> 10000 (:cycle %)))
     (group-by :monke-turn)
     (map (comp count second))
     (sort)
     (take-last 2)
     (reduce *))
