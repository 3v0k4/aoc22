module MyLib (someFunc) where

import Data.List (zip4, nub)

someFunc :: IO ()
someFunc = do
  input <- readFile "./input1.txt"
  print . (+) 3 . firstUnique $ windows 4 input
  print . (+) 13 . firstUnique $ windows 14 input

windows :: Int -> [a] -> [[a]]
windows i [] = [[]]
windows i xs = [take i xs] ++ windows i (tail xs)

firstUnique :: Eq a => [[a]] -> Int
firstUnique =
  fst . head . filter (\(_, zs) -> (length.nub $ zs) == length zs) . zip [1..]
