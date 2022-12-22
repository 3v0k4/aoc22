{-# LANGUAGE TypeApplications #-}

module MyLib (someFunc) where

import Text.Parsec (runParserT, sepEndBy1, many1, digit, (<|>), try, string, getState, modifyState, ParsecT)
import Text.Parsec.Char (char, alphaNum)
import Data.List (transpose)
import Data.Maybe (mapMaybe)
import qualified Data.Map.Strict as M
import Data.Map.Strict ((!))
import Data.List (tails, sort)

data Line
  = CdSlash
  | CdDir String
  | CdUp
  | Ls
  | Dir String
  | FileL File
  deriving (Show)

data File = File [String] String Int
  deriving (Show)

parser :: ParsecT String [String] IO [Line]
parser = (try cdSlash <|> try cdDir <|> try cdUp <|> try ls <|> dir <|> file) `sepEndBy1` (char '\n')

cdSlash :: ParsecT String [String] IO Line
cdSlash = do
  string "$ cd /"
  modifyState (const ["/"])
  pure CdSlash

cdDir :: ParsecT String [String] IO Line
cdDir = do
  string "$ cd "
  name <- many1 alphaNum
  modifyState (\dir -> dir ++ [name])
  pure $ CdDir name

cdUp :: ParsecT String [String] IO Line
cdUp = do
  string "$ cd .."
  modifyState (\dir -> init dir)
  pure CdUp

ls :: ParsecT String [String] IO Line
ls = do
  string "$ ls"
  s <- getState
  pure Ls

dir :: ParsecT String [String] IO Line
dir = do
  string "dir "
  name <- many1 alphaNum
  pure $ Dir name

file :: ParsecT String [String] IO Line
file = do
  size <- read <$> many1 digit
  char ' '
  name <- many1 (alphaNum <|> char '.')
  dir <- getState
  pure . FileL $ File dir name size

isFile :: Line -> Maybe File
isFile (FileL file) = Just file
isFile _ = Nothing

tally :: M.Map [String] Int -> File -> M.Map [String] Int
tally acc (File dir _ size) = foldl tallyH acc (init . tails . reverse $ dir) where
  tallyH accH dH = M.insertWith (+) dH size accH

someFunc :: IO ()
someFunc = do
  input <- readFile "./input1.txt"
  Right lines <- runParserT parser ["/"] "" input
  let files = mapMaybe isFile lines
  let dirs = foldl tally M.empty files
  let lessThan100k = sum . filter (flip (<) 100000) . M.elems $ dirs
  print lessThan100k
  let avail = 70000000 - (dirs M.! ["/"])
  let needed = 30000000 - avail
  let bigEnough = take 1 . filter (flip (>=) needed) . sort . M.elems $ dirs
  print bigEnough
