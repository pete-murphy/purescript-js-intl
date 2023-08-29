module JS.Intl.Options.RoundingIncrement
  ( RoundingIncrement
  , fromInt
  , toInt
  ) where

import Prelude

import Data.Array as Array
import Data.Maybe (Maybe(..))

newtype RoundingIncrement = RoundingIncrement Int

derive instance Eq RoundingIncrement

fromInt :: Int -> Maybe RoundingIncrement
fromInt n =
  if
    Array.elem n [ 1, 2, 5, 10, 20, 25, 50, 100, 200, 250, 500, 1000, 2000, 2500, 5000 ] then
    Just (RoundingIncrement n)
  else Nothing

toInt :: RoundingIncrement -> Int
toInt (RoundingIncrement n) = n
