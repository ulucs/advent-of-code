module Main where
import Utils
import Data.List
import Data.List.Split
import qualified Data.Set as Set
import qualified Data.Map.Strict as Map
import Debug.Trace

parseInp :: String -> [[Int]]
parseInp = map parseDeck . splitOn "\n\n"
  where parseDeck = map read . drop 1 . lines

combat ([[], d]) = d
combat ([d, []]) = d
combat ([c1:d1, c2:d2])
  | c1 > c2 = combat [d1++[c1, c2], d2]
  | otherwise = combat [d1, d2++[c2, c1]]

calcScore = sum . map2 (*) [1..] . reverse

data Winner = P1 | P2 deriving (Eq, Show)

rcombat ([[], d]) sts = (P2, d)
rcombat ([d, []]) sts = (P1, d)
rcombat ds sts
  | w == P1 = rcombat [t1++[c1, c2], t2] $ Set.insert ds sts
  | w == P2 = rcombat [t1, t2++[c2, c1]] $ Set.insert ds sts
  where w = winner ds sts
        [c1:t1, c2:t2] = ds

winner ds sts
  | ds `Set.member` sts = P1
  | c1 < l1 && c2 < l2 = fst $ rcombat [take c1 t1, take c2 t2] Set.empty
  | c1 > c2 = P1
  | c2 > c1 = P2
  where [c1:t1, c2:t2] = ds
        [l1, l2] = map length ds

silver = calcScore . combat . parseInp
gold = calcScore . snd . flip rcombat Set.empty . parseInp

main = do
  inp <- Utils.getInput "22"
  print $ silver inp
  print $ gold inp