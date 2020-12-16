module Main where
import Utils
import Data.List
import Data.List.Split

parseInp inp = (map parseRule r, parseTicket m, map parseTicket ts)
  where [l1, l2, l3] = splitOn "\n\n" inp
        r = lines l1
        m = last $ lines l2
        ts = drop 1 $ filter ((0 /=) . length) $ lines l3
        
parseRule :: String -> (String, [(Integer, Integer)])
parseRule ln = (n, ranges)
  where [n, rgs] = splitOn ": " ln
        rangesS = splitOn " or " rgs
        ranges = map (tuplify . map read . splitOn "-") rangesS

parseTicket :: String -> [Integer]
parseTicket = map read . splitOn ","

validate (_, rgs) num = any (flip inRange num) rgs
  where inRange (a, b) n = a <= n && n <= b

validateAny rules num = any (flip validate num) rules

validatesAll rule ns = all (validate rule) ns

silver inp = sum $ concat $ map (filter (not . validateAny rules)) tickets
  where (rules, _, tickets) = parseInp inp

resolveRules opts
  | all ((1 ==) . length) opts = map head opts
  | otherwise = resolveRules $ map removeSolved opts
    where ones = map head $ filter ((1 ==) . length) opts
          removeSolved ops
            | 1 == length ops = ops
            | otherwise = filter (not . flip elem ones) ops

gold inp = filter (("departure" ==) . take 9 . fst) $ zip ruleOrd ticket
  where ruleOrd = map fst $ resolveRules $ map validRules $ transpose $ validTickets
        validRules ns = filter (flip validatesAll ns) rules
        validTickets = filter (not . any (not . validateAny rules)) aTickets
        (rules, ticket, aTickets) = parseInp inp

main = do
  inp <- Utils.getInput "16"
  print $ silver inp
  print $ gold inp