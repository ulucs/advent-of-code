import Utils
import Data.List

splitS nums = (wrap $ filter (1010 >) nums, reverse $ filter (1010 <) nums)
splitG nums = (combine $ filter (1010 >) nums, reverse $ filter (1010 <) nums)
    where combine = sortOn sum . combs . wrap

findMulti (s:ss) (l:ls)
    | sumd == 2020 = product s * l
    | sumd > 2020 = findMulti (s:ss) ls
    | sumd < 2020 = findMulti ss (l:ls)
    where sumd = sum s + l
findMulti _ _ = 0

wrap = map (:[])

combs ([x]:xs) = map (x:) xs ++ combs xs
combs [] = []

silver = uncurry findMulti . splitS . sort
gold = uncurry findMulti . splitG . sort

main = do
    ns <- Utils.getInputNums "1"
    print $ silver ns
    print $ gold ns
