module Main where
import Utils
import Data.Map.Strict (fromList, (!), Map)
import Data.Maybe
import Data.List
import Data.List.Split

type RuleSet = Map Int RuleRef
data RuleRef = Lit Char | Ref Int | Ropts [[RuleRef]] deriving (Show, Eq)

parseRule :: String -> (Int, RuleRef)
parseRule line = (read name, rule)
  where [name, ruleStr] = splitOn ": " line
        rule
          | '"' `elem` ruleStr = Lit (ruleStr !! 1)
          | otherwise =
              Ropts $ map (map (Ref . read)) $ map (splitOn " ") $ splitOn " | " $ ruleStr

parseInp inp = (fromList $ map parseRule $ reverse $ lines rs, lines is)
  where [rs, is] = splitOn "\n\n" inp

ruleUncons :: RuleSet -> RuleRef -> ([RuleRef], [[RuleRef]])
ruleUncons _ (Lit a) = ([Lit a],  [[]])
ruleUncons rs (Ref i) = ruleUncons rs $ rs ! i
ruleUncons rs (Ropts rfs) = (concat rh, map concat tails)
   where (hs, ts) = unzip $ mapMaybe uncons rfs
         (rh, rt) = unzip $ map (ruleUncons rs) hs
         ls = map length rt
         tails = map2 (:) (concat rt) $ map (:[]) $ concat $ map2 replicate ls ts

valRule _ rr [] = any null rr
valRule _ [[]] _ = False
valRule rs rr (s:ss)
  | passed == [] = False
  | otherwise = valRule rs passed ss
  where rules = uncurry zip $  ruleUncons rs (Ropts rr)
        passed = nub $ map snd $ filter (valsr s) rules
        valsr s (Lit a, _) = a == (s) 

silver inp = filter (valRule rules [[Ref 0]]) strs
  where (rules, strs) = parseInp inp

gold inp = countOn (valRule rules [[Ref 0]]) strs
  where (rules, strs) = parseInp ninp
        ninp = "8: 42 | 42 8\n11: 42 31 | 42 11 31\n" ++ inp

main = do
    inp <- Utils.getInput "19c"
    print $ silver inp
    