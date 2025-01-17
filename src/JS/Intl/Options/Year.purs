-- *** DO NOT EDIT! ***
-- This module is generated by `just generate-options`

module JS.Intl.Options.Year
  ( Year(..)
  , fromString
  , toString
  ) where

import Prelude

import Data.Maybe (Maybe(..))

data Year = TwoDigit | Numeric

derive instance Eq Year

toString :: Year -> String
toString = case _ of
  TwoDigit -> "2-digit"
  Numeric -> "numeric"

fromString :: String -> Maybe Year
fromString = case _ of
  "2-digit" -> Just TwoDigit
  "numeric" -> Just Numeric
  _ -> Nothing
