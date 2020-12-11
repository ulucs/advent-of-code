module Main where
import Utils
import Debug.Trace
import Data.List
import qualified Data.Map.Strict as Map

dirs = filter (/= (0, 0)) $ cartesian [-1, 0, 1] [-1, 0, 1]

ruleS 'L' 0 = '#'
ruleS '#' f
  | f >= 4 = 'L'
  | otherwise = '#'
ruleS x _ = x

countl l (x, y) = countEl (Just '#') . seen
  where seen its = map (seenDir its) dirs
        seenDir its = find (/= '.') . map lookup . map (sum2 (x, y)) . expDir l
        lookup = flip (Map.findWithDefault '.') its
        expDir a = map (uncurry prdSc) . cartesian [1..a] . (:[])

ruleG 'L' 0 = '#'
ruleG '#' f
  | f >= 5 = 'L'
  | otherwise = '#'
ruleG x _ = x

ruleIter rule count its
  | next == its = its
  | otherwise = ruleIter rule count next
  where next = Map.mapWithKey rapply its
        rapply k v = rule v $ count k its

parseInp = map shift . concat . map shiftEach . zip [0..] . map (zip [0..])

silver its = length $ Map.filter ('#' ==) $ ruleIter ruleS (countl 1) its
gold its = length $ Map.filter ('#' ==) $ ruleIter ruleG (countl 100) its

main = do
    inp <- Map.fromList <$> parseInp <$> getInputLines "11"
    print $ silver inp
    print $ gold inp