module Main where
import Utils
import Data.List

toBin :: String -> [Float]
toBin = map conv
    where conv 'F' = 0
          conv 'B' = 1
          conv 'L' = 0
          conv 'R' = 1

toNum :: [Float] -> Float
toNum = sum . map (uncurry (*)) . zip (map (2 **) [0,1..]) . reverse

silver :: [String] -> Float
silver = foldl max 0 . map (toNum . toBin)

deltas :: Num a => [a] -> [a]
deltas xs = map (uncurry (flip (-))) $ zip xs $ tail xs

gold :: [String] -> Maybe Float
gold xs = (1 +) <$> (ss !!) <$> (elemIndex 2 $ deltas ss)
    where ss = sort $ map (toNum . toBin) xs

main = do
    ls <- getInputLines "5"
    print $ silver ls
    print $ gold ls