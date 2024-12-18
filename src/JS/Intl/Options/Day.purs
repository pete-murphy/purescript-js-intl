-- *** DO NOT EDIT! ***
-- This module is generated by `just generate-options`

module JS.Intl.Options.Day
  ( Day(..)
  , fromString
  , toString
  ) where

import Prelude

import Data.Maybe (Maybe(..))

data Day = Numeric | TwoDigit

derive instance Eq Day

toString :: Day -> String
toString = case _ of
  Numeric -> "numeric"
  TwoDigit -> "2-digit"

fromString :: String -> Maybe Day
fromString = case _ of
  "numeric" -> Just Numeric
  "2-digit" -> Just TwoDigit
  _ -> Nothing
