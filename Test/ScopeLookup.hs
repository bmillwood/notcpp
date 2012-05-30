{-# LANGUAGE TemplateHaskell #-}
module Test.ScopeLookup where

import NotCPP.ScopeLookup

main = case $(scopeLookup "putStrLn") of
  Nothing -> error "wat"
  Just putStrLn -> putStrLn "hello world!"
