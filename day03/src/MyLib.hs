{-# LANGUAGE OverloadedStrings #-}

module MyLib (someFunc) where

import qualified Data.Text as T
import Data.Semigroup (Max(..), Sum(..))
import Data.Foldable (fold)
import Data.List (sort, intersect)
import Data.Char (isLower, isUpper, toLower)
import Data.List.Split (chunksOf)
import Data.Bifunctor

halve :: T.Text -> (T.Text, T.Text)
halve text = T.splitAt (T.length text `div` 2) text

score :: Char -> Int
score c
  | isLower c = s c
  | isUpper c = (+) 26 . s . toLower $ c
  | otherwise = 3

s :: Char -> Int
s 'a' = 1
s 'b' = 2
s 'c' = 3
s 'd' = 4
s 'e' = 5
s 'f' = 6
s 'g' = 7
s 'h' = 8
s 'i' = 9
s 'j' = 10
s 'k' = 11
s 'l' = 12
s 'm' = 13
s 'n' = 14
s 'o' = 15
s 'p' = 16
s 'q' = 17
s 'r' = 18
s 's' = 19
s 't' = 20
s 'u' = 21
s 'v' = 22
s 'w' = 23
s 'x' = 24
s 'y' = 25
s 'z' = 26
s  _  = 0

someFunc :: IO ()
someFunc = do
  input <- T.pack <$> readFile "./input1.txt"
  let res1 = sum . fmap (score . head . uncurry intersect . bimap T.unpack T.unpack . halve) . T.lines $ input
  let res2 =  sum . fmap (score . head) . fmap (\[a, b, c] -> intersect c $ intersect b a) . chunksOf 3 . fmap T.unpack . T.lines $ input
  print res1
  print res2
