module Test.Helper where

class C a where
  method :: a -> Bool

instance C Int where
  method _ = True
