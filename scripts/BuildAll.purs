module BuildAll (main) where

import Prelude

import Data.Array (filterA, head)
import Data.Maybe (Maybe, isJust)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Console (logShow)
import Node.FS.Stats (isFile)
import Node.FS.Sync (stat)
import Node.Path (FilePath, basename)
import Utils (cleanPath, isFileItem, isPathDirectory, readPathFor)

main :: Effect Unit
main = do
  directories <- readPathFor isPathDirectory "../exercises/"
  foundNpmDirs <- filterA readForPackageJson directories
  logShow foundNpmDirs
  pure unit


readForPackageJson :: FilePath -> Effect (Boolean)
readForPackageJson directory = do
    foundNpm <- isNPMInDir directory
    pure $ isJust foundNpm

isNPMInDir :: FilePath -> Effect (Maybe FilePath)
isNPMInDir dir = do
  children <- readPathFor isFileItem dir
  absPaths <- traverse cleanPath children
  justPackage <- filterA isPackageJson absPaths
  pure $ head justPackage 

isPackageJson :: FilePath -> Effect Boolean
isPackageJson file = do
  stats <- stat file
  let isNpmRoot = isFile stats && basename file == "package.json"
  pure $ isNpmRoot