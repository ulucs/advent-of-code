{-# LANGUAGE BangPatterns #-}
module Main where
import Utils
import Data.List
import qualified Data.IntMap.Strict as Map
import Debug.Trace

inp = map (read . (:[])) "523764819"

shuffle (x:xs) = concat [npl, [s], picked, npr, [x]]
  where (picked, nonpicked) = splitAt 3 xs
        (npl, _:npr) = break (s ==) nonpicked
        s = head $ ([x-1, x-2 .. 1] ++ [9, 8 ..]) \\ picked

silver inp = rgt ++ lft
  where (lft, _:rgt) = break (1 ==) $ rep 100 shuffle inp

circmap xs = Map.fromList $ zip xs $ tail xs <> [head xs]
next m v = m Map.! v
insMult kvs m = foldl (\ m (k, v) -> Map.insert k v m) m kvs

shuffleM (x, !m) = (nv, insMult shifts m)
  where shifts = [ (sv, head picked)
                 , (last picked, next m sv)
                 , (x, nv) ]
        nv = next m $ last picked
        picked = take 3 $ drop 1 $ iterate (next m) x
        sv = head $ ([x-1, x-2 .. 1] ++ [1000000, 999999 ..]) \\ picked

gold inp = product $ take 2 $ drop 1 $ iterate (next m) 1
  where (_, m) = rep 10000000 shuffleM (5, circmap $ inp ++ [10..1000000])

main = do
    print $ silver inp
    print $ gold inp