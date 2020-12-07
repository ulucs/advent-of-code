module Main where
import Utils
import Data.List.Split
import qualified Data.Map.Strict as Map
import Text.Regex.PCRE

pline :: String -> [String]
pline l = submatches
  where (_, _, _, submatches) = l =~ "(.+?) bags contain ((?:[0-9]+ .+? bag[s, ]*)*)" :: (String, String, String, [String])

pbags :: String -> (String, Int)
pbags "" = ("", 0)
pbags l = (color, read n)
  where (_, _, _, n:color:_) = l =~ "([0-9]+) (.+?) bags?" :: (String, String, String, [String])

tuplify [a, b] = (a, b)

recipes = Map.map items . Map.fromList . map recipe
  where recipe = tuplify . pline
        items = Map.filter (/= 0) . Map.fromList . map pbags . splitOn ", "

silver_ search prev rcp
  | search == Map.empty = prev
  | otherwise = silver_ news nprev rcp
  where news = Map.difference found prev
        nprev = Map.union found prev
        found = Map.filter (not . Map.null . Map.intersection search) rcp

silver ls = length . silver_ start Map.empty $ recipes ls
  where start = Map.fromList [("shiny gold", Map.empty)]

countBags rcp color
  | inBags == Map.empty = 0
  | otherwise = sum $ map r $ Map.toList inBags
  where inBags = rcp Map.! color
        r (c, n) = n * (1 + countBags rcp c)

gold ls = countBags (recipes ls) "shiny gold"

main = do
    ls <- Utils.getInputLines "7"
    print $ silver ls
    print $ gold ls