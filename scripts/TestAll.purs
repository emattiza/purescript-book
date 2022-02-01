module TestAll
  ( main
  )
  where

import Prelude

import Data.Array (filterA)
import Data.Foldable (intercalate)
import Data.Maybe (Maybe(..))
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Console (log)
import Node.ChildProcess (ExecSyncOptions, defaultExecSyncOptions, execSync)
import Node.FS.Stats (isDirectory)
import Node.FS.Sync (readdir, realpath, stat)
import Node.Path (FilePath, concat, normalize)

main :: Effect Unit
main = do
    -- Find exercises folders to run tests against
    contents <- readExercises
    log $ intercalate "\n" contents
    -- Spawn spago test in all exercise directories
    spawnAllTests contents

readExercises :: Effect (Array FilePath)
readExercises = do
  exercises <- cleanPath "../exercises/"
  items <- readdir exercises
  let items_abs_path = (makeAbs exercises) <$> items
  -- filter readdir for only directories
  all_dirs <- filterA isPathDirectory items_abs_path
  pure $ all_dirs

spawnAllTests :: Array FilePath -> Effect Unit
spawnAllTests testDirs = do
  _handles <- spawnTests testDirs
  pure $ unit

spawnTest :: FilePath -> Effect Unit
spawnTest workingDir = do
  log $ "Running spago test on " <> workingDir
  _buffer <- execSync "spago test" opts
  pure unit
  where
    opts :: ExecSyncOptions
    opts = defaultExecSyncOptions {cwd = Just workingDir}

spawnTests :: Array FilePath -> Effect (Array Unit)
spawnTests = traverse (\testDir -> spawnTest testDir)

cleanPath :: String -> Effect FilePath
cleanPath = realpath <<< normalize

makeAbs :: String -> String -> FilePath
makeAbs basePath item = concat [basePath, item]

isPathDirectory :: FilePath -> Effect Boolean
isPathDirectory path = do
  pathStats <- stat path
  pure $ isDirectory pathStats
