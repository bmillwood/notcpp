{-# LANGUAGE TemplateHaskell, ExplicitForAll #-}
{-# OPTIONS_GHC -ddump-splices #-}
module Test.OrphanEvasion where

import Control.Monad
import Language.Haskell.TH

import NotCPP.OrphanEvasion

class C a where
  method :: a -> ()

instance C Int where
  method _ = ()

main = putStrLn $(stringE . unlines =<< mapM (fmap show) [
    safeInstance ''C [t| Int |] [d| method = const () |],
    safeInstance ''C [t| () |] [d| method = id |]])

$(safeInstance ''C [t| () |] [d| method = id |])
