module Main where
import Utils
import Data.List
import Data.List.Split
import Text.Read
import Data.Maybe

parseInpS :: [String] -> (Int, [Int])
parseInpS [t, is] = (read t, mapMaybe readMaybe $ splitOn "," is)

parseInpG :: [String] -> [Maybe Int]
parseInpG [_, is] = map readMaybe $ splitOn "," is

silver (t, ivs) = (tp - t) * fb
    where
      (tp, fb) = findBus t
      findBus t1 = findBus_ t1 $ find ((0 ==) . (t1 `mod`)) ivs
      findBus_ t2 (Just b) = (t2, b)
      findBus_ t2 Nothing = findBus (t2+1)

mods = map extract . filter (isJust . snd) . zip [0..]
    where extract (i, Just a) = ((-i) `mod` a, a)

findModEq lcm acc [] = acc
findModEq lcm acc ((m, i):xs)
  | (acc `mod` i) == m = findModEq (lcm*i) acc xs
  | otherwise = findModEq lcm (acc+lcm) ((m, i):xs)

gold = findModEq 1 0 . mods

main = do
    inp <- Utils.getInputLines "13"
    print $ silver $ parseInpS inp
    print $ gold $ parseInpG inp
