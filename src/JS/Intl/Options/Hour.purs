-- *** DO NOT EDIT! ***
-- This module is generated by `just generate-options`

module JS.Intl.Options.Hour
  ( Hour(..)
  , fromString
  , toString
  ) where

import Prelude

import Data.Maybe (Maybe(..))

data Hour = TwoDigit | Numeric

derive instance Eq Hour

toString :: Hour -> String
toString = case _ of
  TwoDigit -> "2-digit"
  Numeric -> "numeric"

fromString :: String -> Maybe Hour
fromString = case _ of
  "2-digit" -> Just TwoDigit
  "numeric" -> Just Numeric
  _ -> Nothing
