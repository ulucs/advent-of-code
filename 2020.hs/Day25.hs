module Main where
import Utils
import Data.List
import Data.Maybe

readInp :: [String] -> [Integer]
readInp = map read

lssize key = findIndex (key ==) $ iterate (kiter 7) 7
kiter x y = y * x `mod` 20201227

silver inp = rep l1 (kiter k2) k2
    where (Just l1) = lssize k1
          [k1, k2] = readInp inp

main = do
    inp <- Utils.getInputLines "25"
    print $ silver inp