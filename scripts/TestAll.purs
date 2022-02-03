module TestAll
  ( main
  )
  where

import Prelude

import Data.Foldable (intercalate)
import Data.Maybe (Maybe(..))
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Console (log)
import Node.ChildProcess (ExecSyncOptions, defaultExecSyncOptions, execSync)
import Node.Path (FilePath)
import Utils (isPathDirectory, readPathFor)

main :: Effect Unit
main = do
    -- Find exercises folders to run tests against
    contents <- readExercises
    log $ intercalate "\n" contents
    -- Spawn spago test in all exercise directories
    spawnAllTests contents


readExercises :: Effect (Array FilePath)
readExercises = readPathFor isPathDirectory "../exercises/"

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