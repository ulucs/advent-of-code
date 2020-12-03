module Main where
import Utils

countEl x = length . filter (x==)
linesM y = map snd . filter (divides y . fst) . zip ([0,1..] :: [Int])
    where divides y x = x `mod` y == 0

slopeCount (x, y) = countEl '#' . map (uncurry (!!)) . flip zip ([0,x..] :: [Int]) . map cycle . linesM y

silver = slopeCount (3, 1)
gold x = product $ map (flip slopeCount x) [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]

main = do
    ls <- Utils.getInputLines "3"
    print $ silver ls
    print $ gold ls