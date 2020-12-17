module Main where
import Utils
import qualified Data.Map.Strict as Map
import qualified Data.Set as Set

dirs n = filter (replicate n 0 /=) $ rep (n-1) (cartl [-1..1]) $ map (:[]) [-1..1]

parseInp n inp =
    Set.fromList $ map (++ replicate (n-2) 0) [[i,j] | i <- [0..l], j <- [0..l], '#' == inp !! j !! i]
    where l = (length inp) - 1

countAdjs n = Map.toList . countEach . mapcart (map2 (+)) (dirs n) . Set.toList
    where countEach = foldr (\x -> Map.insertWith (+) x 1) Map.empty

iter n actives = Set.fromList $ map fst $ filter lives $ countAdjs n actives
    where lives (crd, k)
            | crd `Set.member` actives = k `elem` [2,3]
            | otherwise = k == 3

solve n = length . rep 6 (iter n) . (parseInp n)

main = do
    inp <- Utils.getInputLines "17"
    print $ solve 3 inp
    print $ solve 4 inp