module Main (main) where

import Control.Monad (unless)
import System.Exit (exitFailure)
import Test.OrphanEvasion (orphanTest)
import Test.ScopeLookup (scopeLookupTest)

-- This is fairly silly. The main test is that it compiles.
main :: IO ()
main = do
  putStrLn ("Orphan tests: " ++ show orphanTest)
  putStrLn ("Scope tests: " ++ show scopeLookupTest)
  unless (orphanTest && scopeLookupTest) $ exitFailure
