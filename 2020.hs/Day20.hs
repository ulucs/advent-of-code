module Main where
import Utils
import Data.List
import Data.List.Split
import qualified Data.Map.Strict as Map
import Data.Map.Strict (Map, (!?), (!))

parseInp :: String -> [(Int, [[Char]])]
parseInp = map readTile . splitOn "\n\n"
  where readTile t = (read tn, tt)
          where tn = map (th !!) [5..8]
                th:tt = lines t

turn 0 = id
turn 1 = map reverse . transpose
turn 2 = reverse . map reverse
turn 3 = transpose . map reverse

tileOpts t = mapcart turn [0..3] [t, reverse t]

fits [Nothing, Nothing] = tileOpts
fits [Just l, Nothing] = filter ((==) (map last l) . map head) . tileOpts
fits [Nothing, Just t] = filter ((==) (last t) . head) . tileOpts
fits [Just l, Just t] = filter (((==) [map last l, last t]) . sides) . tileOpts
  where sides x = [map head x, head x] 

type Piece = [[Char]]
type Board = Map (Int, Int) (Int, Piece)

placePieces :: (Int, Int) -> [(Int, Piece)] -> Board -> [Board]
placePieces (y, x) pieceSet board
  | 144 == length board = [board]
  | otherwise = concat $ map (placePieces ncrd pieceSet) $ placed
  where ncrd = (12*y + x + 1) `divMod` 12
        placed = map (flip (Map.insert (y, x)) board) valids
        valids = concat $ map (\ (a, b) -> shiftEach (a, fits adjs b)) nonrep
        nonrep = filter ((`notElem` exists) . fst) pieceSet
        exists = map fst $ Map.elems board
        adjs = map (\ x -> snd <$> board !? x) [(y, x-1), (y-1, x)]

silver inp = product $ map (fst . (solvd !)) [(0,0), (11, 0), (0, 11), (11, 11)]
  where pcs = parseInp inp
        solvd = head $ placePieces (0, 0) pcs Map.empty

mergeImg = concat . map mmi . divvy 12 12 . Map.elems
  where mmi = transpose . concat . map (transpose . unborder . snd)
        unborder = map (take 8 . tail) . take 8 . tail

countMons str = countOn (monsterAtOffs strm) [(y, x) | y <- [0..(12*8-2)], x <- [0..(12*8-19)]]
  where strm = withInd2 str
        monsterAtOffs strm crd = all ((==) '#') $ map ((strm !) . sum2 crd) monixs
        monixs = Map.keys $ Map.filter ((==) '#') $ withInd2 mons
        mons = lines "                  # \n#    ##    ##    ###\n #  #  #  #  #  #   "

gold inp = countEl '#' (concat merged) - 15 * mxCt
  where mxCt = foldl1 max $ map (countMons) $ tileOpts $ merged
        solvd = head $ placePieces (0, 0) pcs Map.empty
        pcs = parseInp inp
        merged = mergeImg solvd

main = do
    inp <- Utils.getInput "20"
    print $ silver inp
    print $ gold inp