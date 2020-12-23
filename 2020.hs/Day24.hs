module Main where
import Utils
import qualified Data.Map.Strict as Map
import Text.ParserCombinators.Parsec

dirl = sepEndBy dir (string "\n")
dir = many1 $ string "e" <|> string "w" <|> count 2 letter

parseInp :: String -> Either ParseError [[String]]
parseInp = parse dirl "..."

dir2c = Map.fromList [("e", (0, 2)), ("w", (0, -2)),
                      ("ne", (1, 1)), ("sw", (-1, -1)),
                      ("se", (-1, 1)), ("nw", (1, -1))]

silver = length . silver_
silver_ dirs = Map.filter id $ lights
  where lights = foldl (\ m k -> Map.insertWith xor k True m) Map.empty visited
        visited = map (foldl1 sum2 . map (dir2c Map.!)) dirs
        xor True = not

countAdjs = countEach . mapcart sum2 (Map.elems dir2c)
    where countEach = foldr (\x -> Map.insertWith (+) x 1) Map.empty

iter actives = Map.keys $ Map.filterWithKey lives $ countAdjs $ actives
    where lives crd k
            | crd `elem` actives = k `elem` [1, 2]
            | otherwise = k == 2

gold dirs = length $ rep 100 iter init
  where init = Map.keys $ silver_ dirs

main = do
    inp <- Utils.getInput "24"
    let (Right dirs) = parseInp inp

    print $ silver dirs
    print $ gold dirs