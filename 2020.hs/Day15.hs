module Main where
import qualified Data.IntMap.Strict as Map
import Debug.Trace

inp = [1,0,15,2,10,13]

initMap inp = Map.fromList $ zip inp $ map (:[]) [1..]

rep 0 _ = id
rep n f = rep (n-1) f . f

speak (num, mapn, turn) = (next, umap, turn+1)
  where umap = Map.insertWith f next [turn] mapn
        next = say $ mapn Map.! num
        say ([t]) = 0
        say ([t1, t2]) = t1 - t2
        f ([t]) ts = [t, head ts]

silver c inp = a
  where (a, _, _) = rep (c-l) speak (last inp, initMap inp, l+1)
        l = length inp

gold inp = silver 30000000 inp

main = do
    print $ silver 2020 inp
    print $ gold inp