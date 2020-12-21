module Main where
import Utils
import qualified Data.Map.Strict as Map
-- import qualified Data.Set as Set
import Data.List
import Data.List.Split
import Debug.Trace

parseInp inp = (splitOn ", " ajs, splitOn " " ings)
  where ajs = drop 9 $ dropl 1 al
        [ings, al] = splitOn " (" inp

silver inp = sum . map (length . (\\ allerpos)) $ map snd il
  where allerpos = foldl1 union $ map snd ajl
        ajl = algList il
        il = map parseInp inp

algList il = zipf possible allergens
  where possible alg = foldl1 intersect $ map snd $ filter (elem alg . fst) il
        allergens = foldl1 union $ map fst il

resolveAlgs opts
  | all ((1 ==) . length) opts = map head opts
  | otherwise = resolveAlgs $ map removeSolved opts
    where ones = map head $ filter ((1 ==) . length) opts
          removeSolved ops
            | 1 == length ops = ops
            | otherwise = filter (not . flip elem ones) ops

gold inp = concat $ intersperse "," $ map snd matches
    where matches = sortOn fst $ zip ags $ resolveAlgs opts
          (ags, opts) = unzip $ algList il
          il = map parseInp inp

main = do
    inp <- Utils.getInputLines "21"
    print $ silver inp
    print $ gold inp