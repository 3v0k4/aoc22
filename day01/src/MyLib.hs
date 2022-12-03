{-# LANGUAGE OverloadedStrings #-}

module MyLib (someFunc) where

import qualified Data.Text as T
import Data.Semigroup (Max(..), Sum(..))
import Data.Foldable (fold)
import Data.List (sort)

readInt :: T.Text -> Int
readInt = T.read . T.unpack

someFunc :: IO ()
someFunc = do
  input <- T.pack <$> readFile "./input1.txt"
  let elves = fmap (sum . fmap readInt . T.lines) . T.splitOn "\n\n" $ input
  let top1 = maximum elves
  let top3 = sum . take 3 . reverse . sort $ elves
  print top1
  print top3
