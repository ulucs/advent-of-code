module Main where
import Utils
import Data.List
import qualified Data.Map.Strict as Map

parseInp = map parseLine
  where parseLine (d:ds) = (d, read ds :: Int)

dirs = "NESW"
shifts = ((Map.fromList [('R', 1), ('L', -1)]) Map.!)
dir2tup = ((Map.fromList [('E', (1,0)), ('W', (-1,0)), ('N', (0,1)), ('S', (0,-1))]) Map.!)

rotate (x, y) 0 = (x, y)
rotate (x, y) deg = rotate (y, -x) $ mod (deg - 90) 360

cdir (mv, deg) dt
  | mv == 'F' = (dt, dir2tup dt)
  | mv `elem` dirs = (dt, dir2tup mv)
  | otherwise = (nd, (0, 0))
  where
    nd = (dirs !!) $ flip mod 4 $ ix + shift
    shift = (deg `div` 90) * (shifts mv)
    Just ix = elemIndex dt dirs

silver inp = dist1 (0, 0) loc
  where
    (dir, loc) = foldl move ('E', (0, 0)) inp
    move (dt, x0) (mv, a) = (nd, sum2 x0 $ prdSc a md)
      where (nd, md) = cdir (mv, a) dt

gold inp = dist1 (0, 0) loc
  where
    (loc, wpLoc) = foldl move ((0, 0), (10, 1)) inp
    move (loc, wpLoc) (mv, a)
      | mv == 'F' = (sum2 loc $ prdSc a wpLoc, wpLoc)
      | mv `elem` dirs = (loc, sum2 wpLoc $ prdSc a $ dir2tup mv)
      | otherwise = (loc, rotate wpLoc $ a * shifts mv)

main = do
    inp <- parseInp <$> Utils.getInputLines "12"
    print $ silver inp
    print $ gold inp