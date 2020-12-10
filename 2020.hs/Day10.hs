module Main where
import Utils
import Data.List
import Data.List.Split

deltas xs = map (uncurry (-)) $ zip sx (0:sx)
  where sx = sort xs

parseln l = read l :: Int 

silver ls = (countEl 1 ds) * (1 + countEl 3 ds)
    where ds = deltas ls

mCountWays = (map countWays [0 ..] !!)
  where countWays 0 = 1
        countWays 1 = 1
        countWays 2 = 2
        countWays x = countWays (x-3) + countWays (x-2) + countWays (x-1)

gold = product . map (mCountWays . length) . splitOn [3] . deltas

main = do
    ls <- map parseln <$> Utils.getInputLines "10"
    print $ silver ls
    print $ gold ls