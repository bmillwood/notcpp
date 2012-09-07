{-# LANGUAGE TemplateHaskell, ExplicitForAll #-}
{-# OPTIONS_GHC -ddump-splices #-}
module Test.OrphanEvasion where

import Control.Monad
import Language.Haskell.TH

import NotCPP.OrphanEvasion

class C a where
  method :: a -> Bool

instance C Int where
  method _ = True

orphanTest = $(recover [| False |] $ do
  [] <- safeInstance ''C [t| Int |] [d| method = const False |]
  [InstanceD _ _ _] <- safeInstance ''C [t| () |] [d| method = const True |]
  [| True |])
