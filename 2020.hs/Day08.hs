module Main where
import Utils
import Data.Either
import Data.List
import Data.List.Split
import qualified Data.Map.Strict as Map
import qualified Data.Set as Set

parseInp = map (rvals . splitOn " " . filter ('+' /=))
  where rvals [a, b] = (a, read b :: Int)

cmds = Map.fromList [
    ("nop", \ x -> \ (a, s) -> (a, s+1)),
    ("acc", \ x -> \ (a, s) -> (a+x, s+1)),
    ("jmp", \ x -> \ (a, s) -> (a, s+x))
  ]

machine st visited ls or
  | snd st >= length ls = Left (fst st)
  | Set.member (snd st) visited = Right (fst st)
  | otherwise = machine (op x st) (Set.insert (snd st) visited) ls or
  where (ins, x) = ls !! (snd st)
        op = cmds Map.! orins
        orins
          | snd st == or = "nop"
          | otherwise = ins

silver ls = machine (0, 0) Set.empty (parseInp ls)
gold ls = find isLeft $ map (silver ls) jmpIxs
  where jmpIxs = findIndices (("jmp" ==) . fst) (parseInp ls)

main = do
    lns <- Utils.getInputLines "8"
    print $ silver lns $ -1
    print $ gold lns
