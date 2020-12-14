module Main where
import Utils
import Text.Read
import Data.List
import Data.List.Split
import qualified Data.Map.Strict as Map

parseMask :: String -> [Maybe Integer]
parseMask ln = map (readMaybe . (:[])) msk
  where [_, msk] = splitOn " = " ln

parseMem :: String -> (Integer, Integer)
parseMem ln = (read mem, read bit)
  where [tmem, bit] = splitOn "] = " ln
        mem = drop 4 tmem

dec2bin = pad . reverse . d2b
  where
    d2b 0 = []
    d2b n = m:d2b d
      where (d, m) = n `divMod` 2

bin2dec = b2d 1 0 . reverse
  where b2d _ acc [] = acc
        b2d n acc (x:xs) = b2d (n*2) (acc + (x*n)) xs

pad xs = (replicate (36-l) 0) ++ xs
  where l = length xs

maskS (Just x) _ = x
maskS Nothing y = y

maskG (Just 0) y = Just y
maskG (Just 1) x = Just 1
maskG Nothing _ = Nothing

resolveMask mask = rm [[]] $ reverse mask
  where rm acc [] = acc
        rm acc ((Just x):xs) = rm (map (x:) acc) xs
        rm acc (Nothing:xs) = rm (mapcart (:) [0, 1] acc) xs

applyLinesS mem _ [] = mem
applyLinesS mem msk (ln:ls)
  | "mask" == take 4 ln = applyLinesS mem (parseMask ln) ls
  | otherwise = applyLinesS (Map.insert loc mskd mem) msk ls
    where mskd = map2 maskS msk $ dec2bin val
          (loc, val) = parseMem ln

applyLinesG mem _ [] = mem
applyLinesG mem msk (ln:ls)
  | "mask" == take 4 ln = applyLinesG mem (parseMask ln) ls
  | otherwise = applyLinesG (foldr (addToMap val) mem addrs) msk ls
    where addToMap v k mp = Map.insert k v mp
          addrs = resolveMask $ map2 maskG msk $ dec2bin loc
          (loc, val) = parseMem ln

silver = sum . map (bin2dec) . Map.elems . applyLinesS Map.empty []

gold = sum . Map.elems . applyLinesG Map.empty []

main = do
  inp <- Utils.getInputLines "14"
  print $ silver inp
  print $ gold inp