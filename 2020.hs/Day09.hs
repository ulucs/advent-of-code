module Main where
import Utils
import Data.List
import Data.Maybe

psums [] = []
psums (x:xs) = map (x+) xs ++ psums xs

window i xs
    | l <= i = [xs]
    | l > i = (take i xs):(window i $ tail xs)
    where l = length xs

mapi :: [String] -> [Int]
mapi = map read

silver ns = fst <$> find (uncurry notElem) pairs
  where pairs = zip (drop 25 ns) nsums
        nsums = map psums $ window 25 ns

sumsearch st ed sm xs
  | ed >= length xs = Nothing
  | lsum > sm = sumsearch (st+1) ed sm xs
  | lsum < sm = sumsearch st (ed+1) sm xs
  | lsum == sm = Just (maximum arr, minimum arr)
  where lsum = sum arr
        arr = take (ed-st) $ drop st xs

gold s ls = uncurry (+) <$> sumsearch 0 0 s ls

main = do
    ls <- mapi <$> Utils.getInputLines "9"
    let s = fromJust $ silver ls
    print s
    print $ gold s ls
