{-# LANGUAGE OverloadedStrings #-}

module MyLib (someFunc) where

import qualified Data.Text as T
import Data.Semigroup (Max(..), Sum(..))
import Data.Foldable (fold)
import Data.List (sort)

type Move = T.Text

score :: Move -> Move -> Int
score op me = scoreRound op me + scoreMove me

scoreRound :: Move -> Move -> Int
scoreRound "A" "Z" = 0
scoreRound "B" "X" = 0
scoreRound "C" "Y" = 0
scoreRound "A" "X" = 3
scoreRound "B" "Y" = 3
scoreRound "C" "Z" = 3
scoreRound "A" "Y" = 6
scoreRound "B" "Z" = 6
scoreRound "C" "X" = 6
scoreRound  _   _  = 0

scoreMove :: Move -> Int
scoreMove "X" = 1
scoreMove "Y" = 2
scoreMove "Z" = 3
scoreMove _ = 0

type Result = T.Text

myMove :: Move -> Result -> Move
myMove "A" "X" = "Z"
myMove "B" "X" = "X"
myMove "C" "X" = "Y"
myMove "A" "Y" = "X"
myMove "B" "Y" = "Y"
myMove "C" "Y" = "Z"
myMove "A" "Z" = "Y"
myMove "B" "Z" = "Z"
myMove "C" "Z" = "X"
myMove  _   _  = "WTF?"

someFunc :: IO ()
someFunc = do
  input <- T.pack <$> readFile "./input1.txt"
  let rounds = fmap T.words . T.lines $ input
  let res1 = sum . fmap (\[a, b] -> score a b) $ rounds
  let res2 = sum . fmap (\[a, b] -> score a (myMove a b)) $ rounds
  print res1
  print res2
