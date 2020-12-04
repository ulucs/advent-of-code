module Utils where
    import System.Process

    dlInput day = callCommand $ "curl 'https://adventofcode.com/2020/day/" ++ day ++ "/input' -b $(cat ../session.cookie) > inputs/" ++ day ++ ".txt"
    
    getInput day = readFile $ "inputs/" ++ day ++ ".txt" 
    getInputLines = fmap lines . getInput
    getInputNums = fmap (map (read :: String -> Int)) . getInputLines

    countEl x = length . filter (x==)