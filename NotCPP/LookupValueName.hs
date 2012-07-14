{-# LANGUAGE TemplateHaskell #-}
module NotCPP.LookupValueName (
  lookupValueName
 ) where

import Language.Haskell.TH

import NotCPP.Utils

bestValueGuess :: String -> Q (Maybe Name)
bestValueGuess s = do
  mi <- maybeReify (mkName s)
  case mi of
    Nothing -> no
    Just i -> case i of
      VarI n _ _ _ -> yes n
      DataConI n _ _ _ -> yes n
      _ -> err ["unexpected info:", show i]
 where
  no = return Nothing
  yes = return . Just
  err = fail . showString "NotCPP.bestValueGuess: " . unwords

$(recover [d| lookupValueName = bestValueGuess |] $ do
  VarI _ _ _ _ <- reify (mkName "lookupValueName")
  return [])
