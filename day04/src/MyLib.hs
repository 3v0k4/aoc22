{-# LANGUAGE TypeApplications #-}

module MyLib (someFunc) where

import Text.Parsec (parse, sepBy1, sepEndBy1, ParsecT, many1, digit)
import Text.Parsec.Char (char)
import Data.Bifunctor (bimap)
import Data.Set (fromList, isSubsetOf, Set, intersection)
import qualified Data.Set as S (null)

parser = coupleParser `sepEndBy1` (char '\n')
coupleParser = do
  a1 <- areaParser
  char ','
  a2 <- areaParser
  pure (a1, a2)
areaParser = do
  d1 <- read @Integer <$> many1 digit
  char '-'
  d2 <- read @Integer <$> many1 digit
  pure (d1, d2)

setify :: (Integer, Integer) -> Set Integer
setify (x, y) = fromList [x..y]

someFunc :: IO ()
someFunc = do
  Right input <- parse parser "" <$> readFile "./input1.txt"
  let sets = fmap (bimap setify setify) $ input
  let subsets = filter (\(f, s) -> f `isSubsetOf` s || s `isSubsetOf` f) $ sets
  let overlapping = filter (\(f, s) -> not $ S.null $ f `intersection` s) $ sets
  print . length $ subsets
  print . length $ overlapping
