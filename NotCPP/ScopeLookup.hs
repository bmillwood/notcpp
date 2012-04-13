{-# LANGUAGE TemplateHaskell #-}
-- |
-- This module exports 'scopeLookup', which will find a variable or
-- value constructor for you and present it for your use. E.g. at some
-- point in the history of the acid-state package, 'openAcidState' was
-- renamed 'openLocalState'; for compatibility with both, you could
-- use:
--
-- > openState :: IO (AcidState st)
-- > openState = case $(scopeLookup "openLocalState") of
-- >   Just open -> open defaultState
-- >   Nothing -> case $(scopeLookup "openAcidState") of
-- >     Just open -> open defaultState
-- >     Nothing -> error
-- >       "openState: runtime name resolution has its drawbacks :/"
--
module NotCPP.ScopeLookup (
  scopeLookup,
  maybeReify,
 ) where

import Control.Applicative ((<$>))

import Language.Haskell.TH

-- | Produces a spliceable expression which expands to 'Just val' if
-- the given string refers to a value 'val' in scope, or 'Nothing'
-- otherwise.
scopeLookup :: String -> Q Exp
scopeLookup s = recover [| Nothing |] $ do
  Just n <- lookupValueName s
  Just exp <- infoToExp <$> reify n
  [| Just $(return exp) |]

-- | A useful variant of 'reify' that returns 'Nothing' instead of
-- halting compilation when an error occurs (e.g. because the given
-- name was not in scope).
maybeReify :: Name -> Q (Maybe Info)
maybeReify = recoverMaybe . reify

-- | Turns a possibly-failing 'Q' action into one returning a 'Maybe'
-- value.
recoverMaybe :: Q a -> Q (Maybe a)
recoverMaybe q = recover (return Nothing) (Just <$> q)

-- | Returns 'Just (VarE n)' if the info relates to a value called 'n',
-- or 'Nothing' if it relates to a different sort of thing.
infoToExp :: Info -> Maybe Exp
infoToExp (VarI n _ _ _) = Just (VarE n)
infoToExp (DataConI n _ _ _) = Just (ConE n)
infoToExp _ = Nothing
