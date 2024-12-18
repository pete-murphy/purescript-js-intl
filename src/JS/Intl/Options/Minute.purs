-- *** DO NOT EDIT! ***
-- This module is generated by `just generate-options`

module JS.Intl.Options.Minute
  ( Minute(..)
  , fromString
  , toString
  ) where

import Prelude

import Data.Maybe (Maybe(..))

data Minute = Numeric | TwoDigit

derive instance Eq Minute

toString :: Minute -> String
toString = case _ of
  Numeric -> "numeric"
  TwoDigit -> "2-digit"

fromString :: String -> Maybe Minute
fromString = case _ of
  "numeric" -> Just Numeric
  "2-digit" -> Just TwoDigit
  _ -> Nothing
