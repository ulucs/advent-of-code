module Main where
import Utils
import qualified Data.Map.Strict as Map
import Text.ParserCombinators.Parsec

qlist = sepEndBy pqs ssep
pqs = sepBy qs esep
qs = many letter
ssep = string "\n\n"
esep = try (do{ char '\n'
              ; notFollowedBy (char '\n')
           })

parseInp = parse qlist "hoy"

countAns = counts . concat
    where counts = Map.toList . Map.fromListWith (+) . flip zip [1,1..]

silver = sum . map (length . countAns)
gold xs = sum . map (length . fullAns) $ zip sizes $ map countAns xs
    where sizes = map length xs
          fullAns (l, xs) = filter ((l ==) . snd) xs

main = do
    ls <- Utils.getInput "6"
    print $ silver <$> parseInp ls
    print $ gold <$> parseInp ls
