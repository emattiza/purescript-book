module Utils
  ( readPathFor
  , cleanPath
  , isFileItem
  , isPathDirectory
) where

import Prelude

import Data.Array (filterA)
import Effect (Effect)
import Node.FS.Stats (isDirectory, isFile)
import Node.FS.Sync (readdir, realpath, stat)
import Node.Path (FilePath, concat, normalize)

readPathFor :: (String -> Effect Boolean) -> FilePath -> Effect (Array FilePath)
readPathFor testPred path = do
  contents <- cleanPath path
  items <- readdir contents
  let items_abs_path = (makeAbs contents) <$> items
  -- filter readdir for only directories
  all_dirs <- filterA testPred items_abs_path
  pure $ all_dirs


cleanPath :: String -> Effect FilePath
cleanPath = realpath <<< normalize

isPathDirectory :: FilePath -> Effect Boolean
isPathDirectory path = do
  pathStats <- stat path
  pure $ isDirectory pathStats

isFileItem :: FilePath -> Effect Boolean
isFileItem path = do
  pathStats <- stat path
  pure $ isFile pathStats

makeAbs :: String -> String -> FilePath
makeAbs basePath item = concat [basePath, item]