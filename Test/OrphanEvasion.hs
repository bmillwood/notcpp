{-# LANGUAGE TemplateHaskell, ExplicitForAll #-}
module Test.OrphanEvasion where

import Control.Monad
import Language.Haskell.TH

import NotCPP.OrphanEvasion

import Test.Helper

orphanTest = $(do
  [] <- safeInstance ''C [t| Int |] [d| method = const False |]
  [InstanceD _ _ _] <- safeInstance ''C [t| () |] [d| method = const True |]
  [| True |])
