module Utils where
    import System.Process

    dlInput day = callCommand $ "curl 'https://adventofcode.com/2020/day/" ++ day ++ "/input' -b $(cat ../session.cookie) > inputs/" ++ day ++ ".txt"
    
    getInput day = readFile $ "inputs/" ++ day ++ ".txt" 
    getInputLines = fmap lines . getInput
    getInputNums = fmap (map (read :: String -> Int)) . getInputLines

    countOn f = length . filter f
    countEl x = countOn (x ==)

    shift (a, (b, c)) = ((a, b), c)
    shiftEach (a, xs) = zip [a, a..] xs
    distSup (a, b) (x, y) = max (abs (a - x)) (abs (b - y))
    dist1 (a, b) (x, y) = (abs (a - x)) + (abs (b - y))
    sum2 (a, b) (x, y) = (a+x, b+y)
    prdSc a (x, y) = (a*x, a*y)

    tuplify [a, b] = (a, b)

    map2 f xs ys = map (uncurry f) $ zip xs ys
    mapcart f xs ys = map (uncurry f) $ cartesian xs ys
    -- transpose xs = [map (!! i) xs | i <- [0..(l-1)]]
      -- where l = length $ head xs

    cartesian [] ys = []
    cartesian (x:xs) ys = shiftEach (x, ys) ++ cartesian xs ys