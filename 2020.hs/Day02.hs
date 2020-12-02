module Main where
import Utils

xor True False = True
xor False True = True
xor _ _ = False

replace c1 c2 = map repl
    where
        repl c
          | c == c2 = c1
          | otherwise = c

parseLine line = (read a :: Int, read b :: Int, head c, d)
    where
        arrange = replace ' ' '-' . replace ' ' ':'
        (a:b:c:d:_) = words $ arrange line

countEl x = length . filter (x==)

validate (a, b, c, d) = a <= ct && ct <= b
    where ct = countEl c d

validate2 (a, b, c, d) = (ca == c) `xor` (cb == c)
    where
        ca = d !! (a-1)
        cb = d !! (b-1)

silver = countEl True . map (validate . parseLine)
gold = countEl True . map (validate2 . parseLine)

main = do
    ls <- Utils.getInputLines "2"
    print $ silver ls
    print $ gold ls