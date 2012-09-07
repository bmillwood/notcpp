{-# LANGUAGE TemplateHaskell #-}
module Test.ScopeLookup where

import Language.Haskell.TH

import NotCPP.ScopeLookup

scopeLookupTest = $(recover [| False |] $ do
  Just t <- scopeLookup' "True"
  return t)
