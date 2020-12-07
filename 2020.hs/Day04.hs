module Main where
import Utils
import Data.Map (fromList, member, delete, (!), keys, toList)
import Text.ParserCombinators.Parsec
import Text.Regex.PCRE

passList = sepEndBy passport ssep
passport = sepBy pair esep
pair = sepBy unit $ char ':'
unit = many (noneOf "\n: ")
ssep = string "\n\n"
esep = try (do{ char ' ' <|> char '\n'
              ; notFollowedBy (char '\n')
           })

parseInp = parse passList "hoy"

pairify [] = []
pairify (x:xs) = (xa, xb):pairify xs
    where [xa, xb] = x

validation = fromList [
    ("cid", const True),
    ("byr", inRange 1920 2002),
    ("iyr", inRange 2010 2020),
    ("eyr", inRange 2020 2030),
    ("hgt", \ x -> (x =~ "^[0-9]+(cm|in)$" :: Bool) &&
                   (valHeight $ (x =~ "[0-9]+" :: (String, String, String)))),
    ("hcl", \ x -> x =~ "^#[0-9a-f]{6}$" :: Bool),
    ("ecl", flip elem ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]),
    ("pid", \ x -> x =~ "^[0-9]{9}$" :: Bool)]
    where inRange x y z = (read z :: Int) >= x && (read z :: Int) <= y
          valHeight ("", h, t) = (t == "in" && inRange 59 76 h) ||
                                 (t == "cm" && inRange 150 193 h)

silver_ = filter hasKeys . map (fromList . pairify)
    where hasKeys x = all (flip member x) $ keys $ delete "cid" validation
silver = length . silver_

gold = length . filter (validate . toList) . silver_
    where validate = all $ uncurry $ (!) validation

main = do
    txt <- Utils.getInput "4"
    print $ silver <$> parseInp txt
    print $ gold <$> parseInp txt