{-# LANGUAGE TypeApplications #-}

module MyLib (someFunc) where

import Text.Parsec (parse, sepEndBy1, many1, digit, (<|>), try, string, manyTill)
import Text.Parsec.Char (char, upper, anyChar)
import Text.Parsec.String (Parser)
import Data.List (transpose)
import Data.Maybe (catMaybes)

data Move
  = Move Int Int Int
  deriving (Show)

parser :: Parser ([[Char]], [Move])
parser = do
  stacks_ <- stackLine `sepEndBy1` (char '\n')
  let stacks = fmap catMaybes . transpose $ stacks_
  manyTill anyChar (char '\n')
  char '\n'
  moves <- moveParser `sepEndBy1` (char '\n')
  pure (stacks, moves)

stackLine :: Parser [Maybe Char]
stackLine =
  (try emptyCrate <|> crate) `sepEndBy1` (char ' ')

emptyCrate :: Parser (Maybe Char)
emptyCrate = string "   " >> pure Nothing

crate :: Parser (Maybe Char)
crate = do
  char '['
  c <- upper
  char ']'
  pure (Just c)

moveParser :: Parser Move
moveParser = do
  string "move "
  num <- int
  string " from "
  from <- int
  string " to "
  to <- int
  pure $ Move num from to

int :: Parser Int
int = read <$> many1 digit

someFunc :: IO ()
someFunc = do
  Right (stacks, moves) <- parse parser "" <$> readFile "./input1.txt"
  print . fmap head $ move moveSingle stacks moves
  print . fmap head $ move moveMult stacks moves

move :: ([[Char]] -> Move -> [[Char]]) -> [[Char]] -> [Move] -> [[Char]]
move mover stacks [] = stacks
move mover stacks (x:xs) = move mover (mover stacks x) xs

moveSingle :: [[Char]] -> Move -> [[Char]]
moveSingle stacks (Move 0 _ _) = stacks
moveSingle stacks (Move times f t) = moveSingle (moveT stacks (Move 1 f t)) (Move (times-1) f t)

moveMult :: [[Char]] -> Move -> [[Char]]
moveMult stacks move = moveT stacks move

moveT :: [[Char]] -> Move -> [[Char]]
moveT stacks (Move times f t) =
  fmap mapper withIndex
  where
    (toMove, from) = splitAt times $ stacks !! (f-1)
    to = toMove ++ (stacks !! (t-1))
    withIndex = zip [1..length(stacks)] stacks
    mapper (i,xs)
      | i == f = from
      | i == t = to
      | otherwise = xs
