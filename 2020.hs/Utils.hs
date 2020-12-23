{-# LANGUAGE BangPatterns #-}
module Utils where
    import System.Process

    dlInput day = callCommand $ "curl 'https://adventofcode.com/2020/day/" ++ day ++ "/input' -b $(cat ../session.cookie) > inputs/" ++ day ++ ".txt"
    
    getInput day = readFile $ "inputs/" ++ day ++ ".txt" 
    getInputLines = fmap lines . getInput
    getInputNums = fmap (map (read :: String -> Int)) . getInputLines

    countOn f = length . filter f
    countEl x = countOn (x ==)
    
    rep 0 _ x = x
    rep n f !x = rep (n-1) f $ f x

    shift (a, (b, c)) = ((a, b), c)
    shiftEach (a, xs) = zip (repeat a) xs
    distSup (a, b) (x, y) = max (abs (a - x)) (abs (b - y))
    dist1 (a, b) (x, y) = (abs (a - x)) + (abs (b - y))
    sum2 (a, b) (x, y) = (a+x, b+y)
    sum3 (a, b, c) (x, y, z) = (a+x, b+y, c+z)
    sum4 (a,b,c,d) (x,y,z,q) = (a+x,b+y,c+z,d+q)
    prdSc a (x, y) = (a*x, a*y)
    fst3 (a, _, _) = a
    snd3 (_, b, _) = b
    trd3 (_, _, c) = c
    exmid (a, _, c) = (a, c)

    tuplify [a, b] = (a, b)

    dropl n = reverse . drop n . reverse

    map2 f xs ys = map (uncurry f) $ zip xs ys
    mapfst f = map (\ (x, y) -> (f x, y))
    mapsnd f = map (\ (x, y) -> (x, f y))
    zipf f x = zip x $ map f x
    mapcart f xs ys = map (uncurry f) $ cartesian xs ys
    -- transpose xs = [map (!! i) xs | i <- [0..(l-1)]]
      -- where l = length $ head xs
    
    withInd = zip [0..]
    withInd2 = concat . map (map shift . shiftEach) . zip [0..] . map (zip [0..])

    cartesian [] ys = []
    cartesian (x:xs) ys = shiftEach (x, ys) ++ cartesian xs ys

    cartl [] ys = []
    cartl (x:xs) ys = map (x:) ys ++ cartl xs ys
